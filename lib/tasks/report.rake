# encoding: utf-8
include ActionView::Helpers::NumberHelper

namespace :report do

  desc 'List of sold and redeemed vouchers.'
  task vouchers: :environment do
    year = ENV['YEAR'] || Date.today.year
    start_of_year = Time.zone.parse("1.1.#{year}").beginning_of_year
    end_of_year = start_of_year.end_of_year
    params ||= {}
    params[:completed_at_gt] = start_of_year
    params[:completed_at_lt] = end_of_year
    voucher_variants = Spree::Product.active.where(is_gift_card: true).map(&:variants).flatten.map(&:id)
    order_ids = Spree::Order.search(params).result.map(&:id)

    voucher_data = [0,0.0]
    Spree::LineItem.where(variant_id: voucher_variants).each do |line_item|
      next unless order_ids.include?(line_item.order_id)
      voucher_data[0] = voucher_data[0] + 1
      voucher_data[1] = voucher_data[1] + line_item.price
    end
    puts "#{voucher_data.first} verkaufte Gutscheine im Gesamtwert von #{number_to_currency(voucher_data.last, unit: Spree::Config.currency)}"

    voucher_data = [0,0.0]
    redeemed_vouchers = Spree::Adjustment.where(label: "Gutschein").where(adjustable_type: "Spree::Order")
    redeemed_order_ids = Spree::Order.search(params).result.where(id: redeemed_vouchers.map(&:source_id))
    redeemed_vouchers.each do |adjustment|
      next unless redeemed_order_ids.include?(adjustment.source_id)
      voucher_data[0] = voucher_data[0] + 1
      voucher_data[1] = voucher_data[1] + adjustment.amount.abs
    end
    puts "#{voucher_data.first} eingelöste Gutscheine im Gesamtwert von #{number_to_currency(voucher_data.last, unit: Spree::Config.currency)}"

  end

  desc 'List of granted and redeemed store credits.'
  task credits: :environment do
    year = ENV['YEAR'] || Date.today.year
    start_of_year = Time.zone.parse("1.1.#{year}").beginning_of_year
    end_of_year = start_of_year.end_of_year

    params = {}
    params[:created_at_gt] = start_of_year
    params[:created_at_lt] = end_of_year

    result = Spree::StoreCredit.search(params).result
    count = result.count
    sum = result.sum(:amount)
    puts "#{count} gewährte Guthaben im Gesamtwert von #{number_to_currency(sum, unit: Spree::Config.currency)}"

    params = {}
    params[:completed_at_gt] = start_of_year
    params[:completed_at_lt] = end_of_year

    redeemed_credits = Spree::Adjustment.where(label: "Guthaben").where(adjustable_type: "Spree::Order")
    redeemed_order_ids = Spree::Order.search(params).result.where(id: redeemed_credits.map(&:adjustable_id)).map(&:id)
    voucher_data = [0,0.0]
    redeemed_credits.each do |adjustment|
      next unless redeemed_order_ids.include?(adjustment.adjustable_id)
      voucher_data[0] = voucher_data[0] + 1
      voucher_data[1] = voucher_data[1] + adjustment.amount.abs
    end
    puts "#{voucher_data.first} eingelöste Guthaben im Gesamtwert von #{number_to_currency(voucher_data.last, unit: Spree::Config.currency)}"
  end

  desc 'Show weight of a single pig'
  task weight_of_pig: :environment do
    pig_name = ENV['PIG']
    raise 'Usage: bundle exec rake report:weight_of_pig PIG="Schwein 99"' unless pig_name
    option_value = Spree::OptionValue.find_by_name(pig_name)
    weight = 0.0
    option_value.variants.each do |variant|
      weight_of_variant = variant.product.net_weight.to_f
      sold_items = 0
      Spree::LineItem.where(variant_id: variant.id).each do |line_item|
        sold_items += line_item.quantity if line_item.order.complete?
      end
      puts "SOLD: #{variant.id} - #{variant.name}: #{weight_of_variant} * #{sold_items} = #{weight_of_variant * sold_items}"
      weight += (weight_of_variant * sold_items)
    end
    puts (weight / 1000.00).to_i
  end

  desc 'Show all 19% UST stuff.'
  task merchandising: :environment do
    product_ids_with_standard_tax = Spree::TaxCategory.find_by_name("Standardsteuer").product_ids
    variant_ids_with_standard_tax = Spree::Variant.where(product_id: product_ids_with_standard_tax).map(&:id)
    line_items_with_standard_tax = Spree::LineItem.where(variant_id: variant_ids_with_standard_tax)

    year = ENV['YEAR'] || Date.today.year
    start_of_year = Time.zone.parse("1.1.#{year}").beginning_of_year
    end_of_year = start_of_year.end_of_year
    params ||= {}
    params[:completed_at_gt] = start_of_year
    params[:completed_at_lt] = end_of_year

    product_data = [0,0.0]
    order_ids = Spree::Order.search(params).result.map(&:id)
    line_items_with_standard_tax.each do |line_item|
      next unless order_ids.include?(line_item.order_id)
      product_data[0] = product_data[0] + 1
      product_data[1] = product_data[1] + line_item.price
    end

    puts "#{product_data.first} Produkte mit 19% USt im Gesamtwert von #{number_to_currency(product_data.last, unit: Spree::Config.currency)}"

  end

  desc 'Fetch information from google analytics.'
  task weekly: :environment do
    Spree::Role.find_by_name('admin').users.each do |admin|
      ReportMailer.weekly(admin, last_monday, last_sunday).deliver
    end
  end
end

def last_monday
  last_sunday.monday
end

def last_sunday
  if (today = Date.today) == today.sunday
    today
  else
    7.days.ago.sunday.to_date
  end
end

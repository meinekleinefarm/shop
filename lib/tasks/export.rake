# encoding: utf-8
require 'csv'
require 'retentiongrid'

include ActionView::Helpers::NumberHelper

namespace :export do

  desc 'Export products with sku, name, price and so on.'
  task :products => :environment do
    csv_file = ENV['FILE'] || 'products.csv'

    CSV.open(csv_file, "wb", :force_quotes => true) do |csv|
      csv << ["Artikelnummer", "Name", "Gewicht", "Verpackung", "Photo", "VK"]
      Spree::Product.find_each do |product|
        csv << [  product.sku,
                  product.name,
                  number_with_precision(product.weight.to_f, precision: 0),
                  product.container,
                  "http://www.meinekleinefarm.org#{product.images.first.try(:attachment).try(:url, :original)}",
                  number_to_currency(product.price.to_f, :unit => '€', precision: 2)
                ]
      end
    end
  end

  desc 'Export sold and redeemed vouchers.'
  task :vouchers => :environment do
    csv_file = ENV['FILE'] || 'vouchers.csv'
    CSV.open(csv_file, "wb", :force_quotes => true) do |csv|
      csv << ["Kaufdatum", "Bestellnummer", "Warenwert", "Davon Waren mit 19%", "Versandkosten", "Gesamtwert", "Gutschein verkauft", "Gutschein eingelöst", "Guthaben eingelöst"]
      Spree::Order.complete.find_each do |order|

        item_total = order.item_total.to_f
        shipment_total = order.adjustments.where(source_type: "Spree::Shipment").sum(:amount).to_f
        voucher_sold = order.line_items.select{|l| l.product.is_gift_card? }.map(&:price).reduce(:+).to_f
        voucher_redeemed = order.adjustments.where(originator_type: "Spree::GiftCard").sum(:amount).to_f
        credit_total = order.adjustments.where(source_type: "Spree::StoreCredit").sum(:amount).to_f

        default_tax_rate = Spree::TaxRate.where(amount: 0.19).first
        default_tax_category = default_tax_rate.tax_category
        products_with_default_tax = Spree::Product.where(tax_category_id: default_tax_category)

        products_sold_with_default_tax = order.line_items.select{|l| products_with_default_tax.include?(l.product) }.map(&:price).reduce(:+).to_f

        next if voucher_sold == 0.0 && voucher_redeemed == 0.0 && credit_total == 0.0 && products_sold_with_default_tax == 0.0
        csv << [  I18n.l(order.completed_at.to_date),
                  order.number,
                  number_to_currency(item_total, :unit => '', precision: 2),
                  number_to_currency(products_sold_with_default_tax, :unit => '', precision: 2),
                  number_to_currency(shipment_total, :unit => '', precision: 2),
                  number_to_currency(item_total + shipment_total, :unit => '', precision: 2),
                  number_to_currency(voucher_sold, :unit => '', precision: 2),
                  number_to_currency(voucher_redeemed, :unit => '', precision: 2),
                  number_to_currency(credit_total, :unit => '', precision: 2),
                ]
      end
    end
  end

  desc 'All line items within given time range.'
  task line_items: :environment do
    headers = [:name, :number, :completed_at, :quantity, :price, :email, :animal, :category, :hof ]
    start_date = Date.parse(ENV["START"] || '2014-01-01').beginning_of_day
    end_date = Date.parse(ENV["END"] || '2014-12-31').end_of_day
    hof = Spree::Taxonomy.find_by_name('Hof')
    category = Spree::Taxonomy.find_by_name('Art')
    CSV.open('line_items.csv', 'wb', headers: headers) do |csv|
      csv << headers
      Spree::Order.complete.joins(:line_items).where(completed_at: (start_date..end_date)).order('completed_at ASC').find_each do |o|
        o.line_items.each do |i|
          csv << [
            i.product.name,
            o.number,
            o.completed_at,
            i.quantity,
            i.price,
            o.email,
            i.variant.option_values.map(&:name).join('|'),
            i.product.taxons.where(taxonomy_id: category.id).limit(1).first.try(:name),
            i.product.taxons.where(taxonomy_id: hof.id).limit(1).first.try(:name)
          ]
        end
      end
    end
  end

  task orders: :environment do
    headers = [:completed_at, :number, :status, :zahlung, :versand, :email, :gesamt, :produkte, :anpassung ]
    start_date = Date.parse(ENV["START"] || '2014-01-01').beginning_of_day
    end_date = Date.parse(ENV["END"] || '2014-12-31').end_of_day
    CSV.open('orders.csv', 'wb', headers: headers) do |csv|
      csv << headers
      Spree::Order.complete.where(completed_at: (start_date..end_date)).find_each do |o|
        csv << [
          o.completed_at,
          o.number,
          o.state,
          o.payment_state,
          o.shipment_state,
          o.email,
          o.total,
          o.item_total,
          o.adjustment_total
        ]
      end
    end

  end

  task payments: :environment do
    headers = [:number, :completed_at, :status, :zahlungsstatus,:total, :payment_method ]
    start_date = Date.parse(ENV["START"] || '2014-01-01').beginning_of_day
    end_date = Date.parse(ENV["END"] || '2014-12-31').end_of_day
    CSV.open('payed_orders.csv', 'wb', headers: headers) do |csv|
      csv << headers
      Spree::Order.complete.
        joins(:payments).
        where(completed_at: (start_date..end_date)).
        where(payment_state: 'paid').
        order('completed_at ASC').find_each do |o|
          latest_payment = o.payments.order('created_at DESC').limit(1).first
        csv << [
          o.number,
          o.completed_at,
          o.state,
          o.payment_state,
          o.total,
          latest_payment.payment_method.name
        ]
      end
    end
  end
end

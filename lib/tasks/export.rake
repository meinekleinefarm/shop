# encoding: utf-8
require 'csv'
require 'retentiongrid'

include ActionView::Helpers::NumberHelper

namespace :export do

  desc 'Export products with sku, name, price and so on.'
  task :products => :environment do
    csv_file = ENV['FILE'] || 'products.csv'

    CSV.open(csv_file, "wb", :force_quotes => true) do |csv|
      csv << ["Artikelnummer", "Name", "Gewicht", "Verpackung", "Bauer", "Metzger", "VK"]
      Spree::Product.find_each do |product|
        csv << [  product.sku,
                  product.name,
                  number_with_precision(product.weight.to_f, precision: 0),
                  product.container,
                  "",
                  "",
                  number_to_currency(product.price.to_f, :unit => '', precision: 2)
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
end

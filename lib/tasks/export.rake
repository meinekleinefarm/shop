# encoding: utf-8
require 'csv'
require 'retentiongrid'

include ActionView::Helpers::NumberHelper

namespace :export do

  desc 'Export products with sku, name, price and so on.'
  task :products => :environment do
    csv_file = ENV['FILE'] || 'products.csv'
    hof = Spree::Taxonomy.find_by_name('Hof')
    category = Spree::Taxonomy.find_by_name('Art')

    CSV.open(csv_file, "wb") do |csv|
      csv << ["Artikelnummer", "Name", "Kategorie", "Hof", "Gewicht", "Verpackung", "VK"]
      Spree::Product.find_each do |product|
        csv << [  product.sku,
                  product.name,
                  product.taxons.where(taxonomy_id: category.id).limit(1).pluck(:name).first,
                  product.taxons.where(taxonomy_id: hof.id).limit(1).pluck(:name).first,
                  number_with_precision(product.weight.to_f, precision: 0),
                  product.container,
                  number_to_currency(product.price.to_f, :unit => '€', precision: 2)
                ]
      end
    end
  end

  task :products_by_farm => :environment do
    csv_file = ENV['FILE'] || 'hoefe.csv'
    hoefe = Spree::Taxonomy.find_by_name('Hof')
    CSV.open(csv_file, "wb", :force_quotes => true) do |csv|
      csv << ["Hof", "Produkt", "Preis", "sku", "ean"]
      hoefe.taxons.each do |hof|
        hof.products.each do |product|
          csv << [hof.name, product.name, product.price, product.sku, ""]
        end
      end
    end
  end

  desc 'Export sold and redeemed vouchers.'
  task :vouchers => :environment do
    csv_file = ENV['FILE'] || 'vouchers.csv'
    CSV.open(csv_file, "wb", :force_quotes => true) do |csv|
      csv << ["Kaufdatum", "Bestellnummer", "Warenwert", "Davon Waren mit 19%", "Versandkosten", "Gesamtwert", "Gutschein verkauft", "Gutschein eingelöst", "Guthaben eingelöst"]
      Spree::Order.complete.where(state: 'complete').find_each do |order|

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
    I18n.locale = :de
    headers = [:Produkt, :Bestellnummer, :bestellt_am, :Anzahl, :Preis, :email, :Stadt, :PLZ, :Tier, :verfügbar_seit, :Kategorie, :hof ]
    start_date = Date.parse(ENV["START"] || '2014-01-01').beginning_of_day
    end_date = Date.parse(ENV["END"] || '2014-12-31').end_of_day
    hof = Spree::Taxonomy.find_by_name('Hof')
    category = Spree::Taxonomy.find_by_name('Art')
    first_purchase = {}
    CSV.open('line_items.csv', 'wb', headers: headers, col_sep: ';') do |csv|
      csv << headers
      Spree::Order.complete.joins(:line_items).includes(:line_items, :ship_address).where(state: 'complete').where(completed_at: (start_date..end_date)).order('completed_at ASC').each do |o|
        o.line_items.includes(:variant => :option_values, :product => :taxons).each do |i|
          animal = i.variant.option_values.map(&:name).uniq.join('|')
          first_purchase[i.variant] ||= o.completed_at.to_date
          csv << [
            i.product.name,
            o.number,
            I18n.l(o.completed_at.to_date(), format: :export),
            i.quantity,
            number_to_human(i.price, precision: 2),
            o.email,
            o.ship_address.zipcode,
            o.ship_address.city,
            animal,
            I18n.l(first_purchase[i.variant], format: :export),
            i.product.taxons.where(taxonomy_id: category.id).limit(1).pluck(:name).first,
            i.product.taxons.where(taxonomy_id: hof.id).limit(1).pluck(:name).first
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
      Spree::Order.complete.where(state: 'complete').where(completed_at: (start_date..end_date)).find_each do |o|
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
        where(state: 'complete').
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

  task reviews: :environment do
    CSV.open("reviews.csv", "wb", :force_quotes => true) do |csv|
      csv << ["product_handle", "rating", "title","author", "email","body","created_at"]
      Spree::Review.find_each do |review|
        email = review.user.try(:email)
        email ||= 'anonym@meinekleinefarm.org'
        csv << [review.product.try(:permalink), review.rating, review.title, review.name, email, review.review, review.created_at]
      end
    end

  end
end

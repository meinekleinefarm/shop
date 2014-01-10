# encoding: utf-8
require 'csv'

include ActionView::Helpers::NumberHelper

namespace :export do

  desc 'Export products with sku, name, price and so on.'
  task :products => :environment do
    csv_file = ENV['FILE'] || 'products.csv'

    csv_string = CSV.open(csv_file, "wb", :force_quotes => true) do |csv|
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
end

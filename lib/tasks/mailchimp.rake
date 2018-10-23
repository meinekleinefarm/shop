require 'gibbon'
require 'shopify_api'

namespace :mailchimp do
  namespace :members do
    
    def per_page
      100
    end
    
    shop_url =  "https://sdsd:sdsd@example.com.myshopify.com/admin"
    ShopifyAPI::Base.site = shop_url
    
    desc "Update mailchimp member's Last_Order field"
    task :update do
      start_of_week = (Date.today.beginning_of_week - 7.days).to_time
      puts start_of_week
      count = ShopifyAPI::Customer.count()
      puts "Traversing #{count} shopify orders ..."
      pages = (count / per_page) + 2
      for page in 1..pages do
        puts "Page: #{page} ..."
        ShopifyAPI::Customer.find(:all, params: {fields: [:last_order_id, :email], limit: per_page, page: page}).each do |customer|
          next unless customer.last_order_id.present?
          last_order = ShopifyAPI::Order.find(customer.last_order_id, params: {fields: [:id, :created_at, :cancelled_at]})
          next if last_order.cancelled_at.present?
          puts customer.inspect
          puts last_order.inspect
        end
      end
    end
  end
end
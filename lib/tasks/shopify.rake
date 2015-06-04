require 'forgery'

def payment_state(state)
  states = {
    "paid" => "paid",
    "balance_due" => "pending",
    "failed" => "voided"
  }
  states[state]
end

def shipment_state(state)
  states = {
    "shipped" => "fulfilled",
    "ready" => nil,
    "pending" => nil,
    "partial" => "partial"
  }
  states[state]
end


namespace :shopify do

  namespace :upload do

    task customers: :environment do
      Spree::User.all.each do |user|
        new_password = "2b17r2HwlrqNbuRlNtmY" #Forgery(:basic).password(at_least: 32, at_most: 32)
        new_customer = ShopifyAPI::Customer.new
        new_customer.accepts_marketing = user.subscribed?
        new_customer.created_at = user.created_at
        new_customer.updated_at = user.updated_at
        new_customer.email = user.email
        new_customer.verified_email = true
        new_customer.customer_id = user.id
        new_customer.orders_count = user.orders.count
        new_customer.password = new_password
        new_customer.password_confirmation = new_password
        new_customer.send_email_welcome = false
        new_customer.addresses = []
        user.addresses.each do |address|
          new_customer.addresses << {
            address1: address.address1,
            city: address.city,
            phone: address.phone,
            zip: address.zipcode,
            last_name: address.lastname,
            first_name: address.firstname,
            country: address.country.iso
          }
        end
        new_customer.save
      end
    end

    task orders: :environment do
      Spree::Order.complete.limit(10).each do |order|
      user.orders.complete.each do |order|
        new_order  = ShopifyAPI::Order.new
        new_order.customer = ShopifyAPI::Customer.find(:first, email: order.email)
        new_order.billing_address = {
          first_name: order.billing_address.firstname,
          last_name: order.billing_address.lastname,
          address1: order.billing_address.address1,
          phone: order.billing_address.phone,
          city: order.billing_address.city,
          country: order.billing_address.country.iso,
          zip: order.billing_address.zipcode
        }
        new_order.shipping_address = {
          first_name: order.shipping_address.firstname,
          last_name: order.shipping_address.lastname,
          address1: order.shipping_address.address1,
          phone: order.shipping_address.phone,
          city: order.shipping_address.city,
          country: order.shipping_address.country.iso,
          zip: order.shipping_address.zipcode
        }
        new_order.email = order.email
        new_order.total_line_items_price = order.item_total
        new_order.total_price = order.total
        new_order.order_id = order.number
        new_order.currency = order.currency
        new_order.name = order.number
        new_order.created_at = order.created_at
        new_order.updated_at = order.updated_at
        new_order.source_name = "spree"
        new_order.financial_status = payment_state(order.payment_state)
        new_order.fulfillment_status = shipment_state(order.shipment_state)
        new_order.line_items = []
        order.line_items.each do |line_item|
          new_order.line_items << {
            variant_id: 1,
            quantity: line_item.quantity,
            price: line_item.price,
            title: line_item.variant.name,
            name: line_item.variant.name
          }
        end
        new_order.save
      end
    end

    desc 'Upload all products to shopify'
    task products: :environment do

      hof = Spree::Taxonomy.find_by_name('Hof')
      category = Spree::Taxonomy.find_by_name('Art')
      Spree::Product.where("count_on_hand > 0").limit(10).each do |product|
        # Create a new product
        new_product = ShopifyAPI::Product.new
        new_product.product_id = product.id
        new_product.sku = product.sku
        new_product.title = product.name
        new_product.body_html = product.description
        new_product.price = product.price
        new_product.weight = product.weight
        new_product.handle = product.permalink
        new_product.product_type = product.taxons.where(taxonomy_id: category.id).limit(1).pluck(:name).first
        new_product.vendor = product.taxons.where(taxonomy_id: hof.id).limit(1).pluck(:name).first
        new_product.requires_shipping = true
        new_product.inventory_management = 'shopify'
        new_product.published_at = product.available_on
        new_product.save

        product.images.select{|i| i.viewable.is_master? }.each do |image|
          new_image = ShopifyAPI::Image.new
          new_image.src = "http://www.meinekleinefarm.org#{image.attachment.url(:original)}"
          new_image.prefix_options = { product_id: new_product.id }
          new_image.save
        end

        product.variants.each do |variant|

          variant.images.each do |image|
            new_image = ShopifyAPI::Image.new
            new_image.src = "http://www.meinekleinefarm.org#{image.attachment.url(:original)}"
            new_image.prefix_options = { product_id: new_product.id }
            new_image.save
          end

          new_variant = ShopifyAPI::Variant.new
          new_variant.grams = variant.weight
          new_variant.inventory_quantity = variant.count_on_hand
          new_variant.title = variant.option_values.first.name
          new_variant.option1 = variant.option_values.first.name
          new_variant.price = variant.price
          new_variant.prefix_options = { product_id: new_product.id }
          new_variant.image_id = new_image.id
          new_variant.inventory_management = 'shopify'
          new_variant.save

        end
      end

    end
  end
end
end
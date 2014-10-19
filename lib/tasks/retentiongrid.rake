require 'ruby-progressbar'
namespace :retentiongrid do

  namespace :reset do

    desc 'Reset all orders at retentiongrid.com'
    task orders: :environment do
      progress_bar = ProgressBar.create(:title => "orders", :format => '%a |%b>>%i| %C %t', :total => Spree::Order.complete.count )
      Spree::Order.complete.order('completed_at DESC').find_each do |order|
        Retentiongrid::Order.find(order.number).try(:destroy)
        progress_bar.increment
      end
    end

    desc 'Reset all customers at retentiongrid.com'
    task customers: :environment do
      progress_bar = ProgressBar.create(:title => "customers", :format => '%a |%b>>%i| %C %t', :total => customer_emails.count )
      customer_emails.each do |email|
        customer_id = normalized_customer_id(email)
        Retentiongrid::Customer.find(customer_id).try(:destroy)
        progress_bar.increment
      end
    end

    desc 'Reset all products at retentiongrid.com'
    task products: :environment do
      progress_bar = ProgressBar.create(:title => "products", :format => '%a |%b>>%i| %C %t', :total => Spree::Product.count )
      Spree::Product.find_each do |product|
        Retentiongrid::Product.find(product.id).try(:destroy)
        progress_bar.increment
      end
    end
  end

  namespace :submit do
    desc 'Send all product information to retentiongrid.com'
    task products: :environment do
      progress_bar = ProgressBar.create(:title => "products", :format => '%a |%b>>%i| %C %t', :total => Spree::Product.count )
      Spree::Product.find_each do |product|
        metadata_hash = {}
        product.taxons.each do |taxon|
          metadata_hash[taxon.taxonomy.try(:name)] = taxon.name
        end
        Retentiongrid::Product.new({
          product_id: product.id,
          title: product.name,
          product_url: "http://#{Spree::Config.site_url}/products/#{product.permalink}",
          available: product.available?,
          image_url: "http://#{Spree::Config.site_url}#{product.images.try(:first).try(:attachment).try(:url, :original)}",
          currency: product.currency,
          price: product.price.to_f,
  #          sale_price:
          cost_price: product.cost_price,
          product_created_at: product.created_at,
          product_updated_at: product.updated_at,
          metadata: metadata_hash
        }).save
        progress_bar.increment
      end
    end

    desc 'Send all customer information to retentiongrid.com'
    task customers: :environment do
      progress_bar = ProgressBar.create(:title => "customers", :format => '%a |%b>>%i| %C %t', :total => customer_emails.count )
      customer_emails.each do |email|
        order = Spree::Order.complete.where(email: email).order('completed_at DESC').limit(1).try(:first)
        customer_id = normalized_customer_id(email)
        retentiongrid_customer = Retentiongrid::Customer.new({
          customer_id:        customer_id,
          full_name:          order.name,
          email:              order.email,
          country:            order.shipping_address.try(:country).try(:iso),
          city:               order.shipping_address.try(:city),
          postal_code:        order.shipping_address.try(:zipcode),
          accepts_email_marketing:  order.user.try(:subscribed?)
        })
        retentiongrid_customer.save
        progress_bar.increment
      end
    end

    desc 'Send all order information to retentiongrid.com'
    task orders: :environment do
      progress_bar = ProgressBar.create(:title => "orders", :format => '%a |%b>>%i| %C %t', :total => Spree::Order.complete.count )
      Spree::Order.complete.order('completed_at DESC').each do |order|
        customer_id = normalized_customer_id(order.email)
        retentiongrid_order = Retentiongrid::Order.new({
          status:           'ok',
          order_id:         order.number,
          customer_id:      customer_id,
          currency:         order.currency,
          total_price:      order.item_total.to_f,
          total_discounts:   order.total_discount,
          order_created_at: order.completed_at.to_s,
        })
        retentiongrid_order.save

        # order.line_items.each do |line_item|
        #   retentiongrid_line_item = Retentiongrid::LineItem.new({
        #     line_item_id: line_item.id,
        #     order_id: order.id,
        #     price: line_item.price.to_f,
        #     quantity: line_item.quantity,
        #     product_id: line_item.product.id,
        #     variant_id: line_item.variant_id,
        #     sku: line_item.variant.sku,
        #     name: line_item.variant.name
        #   })
        #   retentiongrid_line_item.save
        # end
        progress_bar.increment
      end
    end
  end
end


def customer_emails
   Spree::Order.complete.order('completed_at DESC').map(&:email).uniq
end

def normalized_customer_id(email)
  email.gsub(/@/, '_at_').gsub(/\./,'_')
end
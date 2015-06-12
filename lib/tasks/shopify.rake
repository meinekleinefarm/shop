

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

    desc "Upload all blog articles"
    task blogs: :environment do
      Spree::Blog.all.each do |blog|
        shopify_blog = Shopify::BlogAdapter.new(blog).to_shopify
        shopify_blog.save
        blog.posts.each do |post|
          post_adapter = Shopify::ArticleAdapter.new(post, shopify_blog).to_shopify
          post_adapter.save
        end
      end
    end

    desc "Upload all customers"
    task customers: :environment do
      Spree::User.all.each do |user|
        shopify_customer = Shopify::CustomerAdapter.new(user).to_shopify
        shopify_customer.save
      end
    end

    desc "Upload all orrders"
    task orders: :environment do
      Spree::Order.complete.each do |order|
        shopify_order = Shopify::OrderAdapter.new(order).to_shopify
        shopify_order.save
      end
    end

    desc "Upload all products"
    task products: :environment do
      Spree::Product.where("count_on_hand > 0").each do |product|
        shopify_product = Shopify::ProductAdapter.new(product).to_shopify
        shopify_product.save
        putc '.'
      end
    end

    desc 'Upload all static pages'
    task pages: :environment do
      Spree::Page.limit(10).each do |page|
        shopify_page = Shopify::PageAdapter.new(page).to_shopify
        shopify_page.save
        putc '.'
      end
    end

  end
end
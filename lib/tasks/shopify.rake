require 'ruby-progressbar'

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
      progress_bar = ProgressBar.create(:title => "customers", :format => '%a |%b>>%i| %C %t', :total => Spree::User.count )
      Spree::User.find_each do |user|
        shopify_customer = ShopifyAPI::Customer.find(:first, :from => :search, :params => { :q => "email:#{user.email}"}) || ShopifyAPI::Customer.new
        shopify_customer.attributes = shopify_customer.attributes.merge(Shopify::CustomerAdapter.new(user).attributes)
        shopify_customer.save
        progress_bar.increment
      end
    end

    desc "Upload all orrders"
    task orders: :environment do
      progress_bar = ProgressBar.create(:title => "orders", :format => '%a |%b>>%i| %C %t', :total => Spree::Order.complete.count )
      Spree::Order.order('completed_at DESC').each do |order|
        shopify_order = ShopifyAPI::Order.find(:first, params: {name: "#{order.number}"}) || ShopifyAPI::Order.new
        shopify_order.attributes = shopify_order.attributes.merge(Shopify::OrderAdapter.new(order).attributes)
        shopify_order.save
        progress_bar.increment
      end
    end

    desc "Upload all products"
    task products: :environment do
      progress_bar = ProgressBar.create(:title => "products", :format => '%a |%b>>%i| %C %t', :total => Spree::Product.where("count_on_hand > 0").count )
      Spree::Product.where("count_on_hand > 0").each do |product|
        shopify_product = Shopify::ProductAdapter.new(product).to_shopify
        shopify_product.save
        progress_bar.increment
      end
    end

    desc 'Upload all static pages'
    task pages: :environment do
      progress_bar = ProgressBar.create(:title => "pages", :format => '%a |%b>>%i| %C %t', :total => Spree::Page.count )
      Spree::Page.each do |page|
        shopify_page = Shopify::PageAdapter.new(page).to_shopify
        shopify_page.save
        progress_bar.increment
      end
    end

  end
end
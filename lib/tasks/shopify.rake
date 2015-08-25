require 'ruby-progressbar'

namespace :shopify do

  namespace :upload do

    def bar_format
      '%e |%b>%i| %c/%C %t'
    end

    def per_page
      250
    end

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
      progress_bar = ProgressBar.create(:title => "customers", :format => bar_format, :total => Spree::User.count )
      Spree::User.find_each do |user|
        shopify_customer = ShopifyAPI::Customer.find(:first, :from => :search, :params => { :q => "email:#{user.email}"}) || ShopifyAPI::Customer.new
        shopify_customer.attributes = shopify_customer.attributes.merge(Shopify::CustomerAdapter.new(user).attributes)
        shopify_customer.save
        progress_bar.increment
      end
    end

    desc "Upload all orrders"
    task orders: :environment do
      progress_bar = ProgressBar.create(:title => "orders", :format => bar_format, :total => Spree::Order.complete.count )
      Spree::Order.order('completed_at DESC').each do |order|
        shopify_order = ShopifyAPI::Order.find(:first, params: {name: "#{order.number}"}) || ShopifyAPI::Order.new
        shopify_order.attributes = shopify_order.attributes.merge(Shopify::OrderAdapter.new(order).attributes)
        shopify_order.save
        progress_bar.increment
      end
    end

    desc "Upload all products"
    task products: :environment do
      progress_bar = ProgressBar.create(:title => "products", :format => bar_format, :total => Spree::Product.where("count_on_hand > 0").count )
      Spree::Product.where("count_on_hand > 0").each do |product|
        shopify_product = Shopify::ProductAdapter.new(product).to_shopify
        shopify_product.save
        progress_bar.increment
      end
    end

    desc 'Upload all static pages'
    task pages: :environment do
      progress_bar = ProgressBar.create(:title => "pages", :format => bar_format, :total => Spree::Page.count )
      Spree::Page.each do |page|
        shopify_page = Shopify::PageAdapter.new(page).to_shopify
        shopify_page.save
        progress_bar.increment
      end
    end

  end

  namespace :delete do

    desc 'Delete everything from the shopify shop'
    task all: [ :orders, :customers, :products, :blogs, :pages ] do
      puts "DONE"
    end

    desc 'Delete all shopify orders'
    task orders: :environment do
      count = ShopifyAPI::Order.count({params: {status: :any}})
      pages = (count / per_page) + 2
      progress_bar = ProgressBar.create(:title => "orders", :format => bar_format, :total => count )
      for page in 1..pages do
        ShopifyAPI::Order.find(:all, params: {status: :any, limit: per_page, page: page }).each do |order|
          begin
            ShopifyAPI::Order.delete(order.id)
            progress_bar.increment
          rescue ActiveResource::ClientError => e
            sleep 2
            retry
          end
        end
      end
    end

    desc 'Delete all shopify orders'
    task customers: [:orders] do
      count = ShopifyAPI::Customer.count
      pages = (count / per_page) + 2
      progress_bar = ProgressBar.create(:title => "customers", :format => bar_format, :total => count )
      for page in 1..pages do
        ShopifyAPI::Customer.find(:all, params: { limit: per_page, page: page }).each do |customer|
          begin
            ShopifyAPI::Customer.delete(customer.id)
            progress_bar.increment
          rescue ActiveResource::ClientError => e
            sleep 2
            retry
          end
        end
      end
    end

    desc 'Delete all shopify products'
    task products: :environment do
      count = ShopifyAPI::Product.count
      pages = (count / per_page) + 2
      progress_bar = ProgressBar.create(:title => "products", :format => bar_format, :total => count )
      for page in 1..pages do
        ShopifyAPI::Product.find(:all, params: { status: :any, limit: per_page, page: page }).each do |product|
          begin
            ShopifyAPI::Product.delete(product.id)
            progress_bar.increment
          rescue ActiveResource::ClientError => e
            sleep 2
            retry
          end
        end
      end
    end

    desc 'Delete all shopify blogs'
    task blogs: :environment do
      count = ShopifyAPI::Blog.count
      pages = (count / per_page) + 2
      progress_bar = ProgressBar.create(:title => "blogs", :format => bar_format, :total => count )
      for page in 1..pages do
        ShopifyAPI::Blog.find(:all, params: { limit: per_page, page: page }).each do |blog|
          begin
            ShopifyAPI::Blog.delete(blog.id)
            progress_bar.increment
          rescue ActiveResource::ClientError => e
            sleep 2
            retry
          end
        end
      end
    end

    desc 'Delete all shopify pages'
    task pages: :environment do
      count = ShopifyAPI::Page.count
      pages = (count / per_page) + 2
      progress_bar = ProgressBar.create(:title => "pages", :format => bar_format, :total => count )
      for page in 1..pages do
        ShopifyAPI::Page.find(:all, params: { limit: per_page, page: page }).each do |p|
          begin
            ShopifyAPI::Page.delete(p.id)
            progress_bar.increment
          rescue ActiveResource::ClientError => e
            sleep 2
            retry
          end
        end
      end
    end


  end
end
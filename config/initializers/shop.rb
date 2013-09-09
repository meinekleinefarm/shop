require 'spree/shop_configuration'

module Spree
  Shop::Application::Config = Spree::ShopConfiguration.new
end

Shop::Application::Config[:theme] = "spree_mkf_theme"
Shop::Application::Config[:show_splash_page] = true
Shop::Application::Config[:number_of_articles] = 5
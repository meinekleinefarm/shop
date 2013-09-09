module Spree

  class ShopConfiguration < Spree::Preferences::Configuration
    preference :theme, :string, :default => "Default"
    preference :show_splash_page, :boolean
    preference :number_of_articles, :integer
  end
end
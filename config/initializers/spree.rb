# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to override the default site name.
  config.site_name = "MeineKleineFarm.org Shop"
  config.default_seo_title = "MeinekleineFarm.org Shop"
  config.site_url = "shop.meinekleinefarm.org"
  config.emails_sent_from = "shop@meinekleinefarm.org"
  config.default_meta_keywords = "Shop Meine kleine Farm Bio Freilandhaltung Respekt Bewurstsein"
  config.default_meta_description = "Wir geben Wurst ein Gesicht!"
#  config.default_locale = 'de'
  config.allow_ssl_in_production = true
  config.currency = 'EUR'
  config.display_currency = false
  config.default_country_id = 74
  config.currency_symbol_position = "after"
  config.prices_inc_tax = true
  config.currency_decimal_mark = ','
  config.currency_thousands_separator = '.'
  config.shipment_inc_vat = false
  config.address_requires_state = false
  config.attachment_default_url = '/system/spree/products/:id/:style/:basename.:extension'
  config.attachment_path = ':rails_root/public/spree/products/:id/:style/:basename.:extension'
  config.attachment_url = '/spree/products/:id/:style/:basename.:extension'
  config.attachment_styles = "{\"mini\":\"100x100#\",\"small\":\"420x420#\",\"product\":\"460x345#\",\"large\":\"600x600>\"}"
  config.auto_capture = true
  config.products_per_page = 100
  config.admin_products_per_page = 20
end

Spree.user_class = "Spree::User"

SpreeEditor::Config.tap do |config|
  config.ids = "product_description taxon_description schwein_description page_body event_body"
end
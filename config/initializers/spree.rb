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
  config.site_name = "MeineKleineFarm.org"
#  config.default_locale = 'de'
  config.allow_ssl_in_production = false
  config.currency = 'EUR'
  config.display_currency = false
  config.default_country_id = 74
  config.currency_symbol_position = "after"
  config.prices_inc_tax = true
  config.shipment_inc_vat = false
  config.address_requires_state = false
  config.attachment_default_url = '/system/spree/products/:id/:style/:basename.:extension'
  config.attachment_path = ':rails_root/public/system/spree/products/:id/:style/:basename.:extension'
  config.attachment_url = '/system/spree/products/:id/:style/:basename.:extension'
  config.attachment_styles = "{\"mini\":\"48x48#\",\"small\":\"148x148#\",\"product\":\"460x345#\",\"large\":\"600x600>\"}"
end

Spree.user_class = "Spree::User"

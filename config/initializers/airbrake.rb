require 'yaml'
airbrake_config = YAML.load_file("#{Rails.root}/config/airbrake.yml")

Airbrake.configure do |config|
  config.api_key = airbrake_config[Rails.env]['api_key']
  config.secure = true
  config.logger = Logger.new(Rails.root.join('log', 'airbrake.log'))
end

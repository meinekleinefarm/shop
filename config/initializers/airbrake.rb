Airbrake.configure do |config|
  config.api_key = '62c1649d6fe95c19e72043eb2bd90ad9'
  config.secure = true
  config.logger = Logger.new(Rails.root.join('log', 'airbrake.log'))
end

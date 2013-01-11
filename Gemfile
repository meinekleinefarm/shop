source 'https://rubygems.org'


group :default do

  gem 'rails', '3.2.11'

  # Bundle edge Rails instead:
  # gem 'rails', :git => 'git://github.com/rails/rails.git'

  gem 'mysql2'
  gem 'jquery-rails'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'


group :deployment do
  # Use unicorn as the app server
  gem 'unicorn'
  # Deploy with Capistrano
  gem 'capistrano'
end


# To use debugger
# gem 'debugger'
gem 'spree', '1.3.0'
gem 'spree_gateway', :github => 'spree/spree_gateway'
gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => 'edge'
gem 'spree_i18n', :git => 'git://github.com/spree/spree_i18n.git', :branch => '1-3-stable'
gem 'spree_mkf_theme', :path => '../spree_mkf_theme'

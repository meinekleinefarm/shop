source 'https://rubygems.org'


group :default do

  gem 'rails', '3.2.21'

  # Bundle edge Rails instead:
  # gem 'rails', :git => 'git://github.com/rails/rails.git'
  gem 'haml'

  # gem 'mysql2'
  gem 'pg'
  gem 'jquery-rails' #, '~> 2.1.4'

  gem 'tinymce-rails'
  gem 'tinymce-rails-langs'

  gem 'i18n'
  gem 'rails-i18n'
  gem 'html2markdown'
  gem 'airbrake'

  gem 'retentiongrid'
  # gem 'retentiongrid', path: '../retentiongrid'
  gem 'ruby-progressbar', require: false

  gem 'newrelic_rpm'

  gem 'figaro'
  gem 'shopify_api'
  gem 'forgery', require: false
  gem 'redcarpet'
  gem 'chunky_png'
  gem 'barby'

  gem 'daemons'
  gem 'delayed_job_active_record'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3'
end

group :test, :development do
  gem 'rb-fsevent'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-pow',     require: false
  gem 'guard-bundler', require: false

  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'launchy'
end

group :development do
  gem 'ruby-graphviz'
  gem 'better_errors'
  gem 'binding_of_caller'

  # Deploy with Capistrano
  gem 'capistrano',       '~> 3.0.0'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
end

group :production, :staging do
  # Use unicorn as the app server
  gem 'unicorn'
  gem 'memcache-client'
  gem 'rack-statsd'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'debugger'
gem 'spree', '1.3.5'
gem 'spree_gateway',            :git => 'git://github.com/spree/spree_gateway',                       :branch => '1-3-stable'
gem 'spree_auth_devise',        :git => 'git://github.com/spree/spree_auth_devise',                   :branch => '1-3-stable'
gem 'spree_i18n',               :git => 'git://github.com/spree/spree_i18n.git',                      :branch => '1-3-stable'

gem 'spree_paypal_express',     :git => 'git://github.com/radar/better_spree_paypal_express',         :branch => '1-3-stable'
#gem 'spree_paypal_express',     :git => 'git://github.com/meinekleinefarm/better_spree_paypal_express',:branch => '1-3-stable'
#gem 'spree_paypal_express',     :path => '../better_spree_paypal_express'

#gem 'spree_reviews',            :git => 'git://github.com/spree/spree_reviews.git',                   :branch => '1-3-stable'
gem 'spree_reviews',            :git => 'git://github.com/meinekleinefarm/spree_reviews.git',          :branch => '1-3-stable'
#gem 'spree_reviews',            :path => '../spree_reviews'

gem 'spree_editor',             :git => 'git://github.com/spree/spree_editor.git',                    :branch => '1-3-stable'

gem 'spree_store_credits',      :git => 'git://github.com/spree/spree_store_credits.git',             :branch => '1-3-stable'
#gem 'spree_store_credits',      :git => 'git://github.com/meinekleinefarm/spree_store_credits.git',   :branch => '1-3-stable'
#gem 'spree_store_credits',      :path => '../spree_store_credits'

gem 'spree_contact_us',         :git => 'git://github.com/jdutil/spree_contact_us.git',               :branch => '1-3-stable'
gem 'spree_social_products',    :git => 'git://github.com/spree/spree_social_products.git',           :branch => '1-3-stable'

gem 'spree_essentials',         :git => 'git://github.com/meinekleinefarm/spree_essentials',          :branch => '1-3-stable'
#gem 'spree_essentials',         :path => '../spree_essentials'

gem 'spree_essential_cms',      :git => 'git://github.com/coupling/spree_essential_cms',              :branch => '1-3-stable'

gem 'spree_essential_blog',     :git => 'git://github.com/meinekleinefarm/spree_essential_blog',      :branch => '1-3-stable'
#gem 'spree_essential_blog',             :path => '../spree_essential_blog'

gem 'spree_essential_menus',    :git => 'git://github.com/meinekleinefarm/spree_essential_menus.git'
#gem 'spree_essential_menus',    :path => '../spree_essential_menus'

gem 'spree_gift_card',          :git => 'git://github.com/meinekleinefarm/spree_gift_card.git',       :branch => 'mkf'
#gem 'spree_gift_card',          :path => '../spree_gift_card',                                        :branch => 'mkf'

gem 'spree_bank_transfer',      :git => 'git://github.com/meinekleinefarm/spree-bank-transfer',       :branch => 'master'
#gem 'spree_bank_transfer',      :path => '../spree-bank-transfer'

gem 'spree_mkf_theme',          :git => 'git://github.com/meinekleinefarm/spree_mkf_theme',           :branch => 'master'
#gem 'spree_mkf_theme',          :path => '../spree_mkf_theme'

gem 'spree_export',             :git => 'git://github.com/meinekleinefarm/spree_export.git'
#gem 'spree_export',             :path => '../spree_export'

gem 'spree_address_book',       :git => "git://github.com/meinekleinefarm/spree_address_book.git",    :branch => '1-3-stable'
#gem 'spree_address_book',       :path => '../spree_address_book'

gem 'spree_packstation',       :git => "git://github.com/meinekleinefarm/spree_packstation.git",      :branch => '1-3-stable'
#gem 'spree_packstation',        :path => '../spree_packstation'

gem 'spree_advanced_reporting', :git => 'git://github.com/meinekleinefarm/spree_advanced_reporting.git',  :branch => '1-3-stable'
#gem 'spree_advanced_reporting', :path => '../spree_advanced_reporting'

#gem "spree_chimpy",             :git => "git://github.com/DynamoMTL/spree_chimpy",                     :branch => '1-3-stable'
gem "spree_chimpy",             :git => "git://github.com/meinekleinefarm/spree_chimpy",                     :branch => '1-3-stable'
#gem 'spree_chimpy',             :path => '../spree_chimpy'

gem 'spree_sofort',             :git => 'git://github.com/hefan/spree_sofort.git',                      :branch => '1-3-stable'
#gem 'spree_sofort',             :git => 'git://github.com/meinekleinefarm/spree_sofort.git',            :branch => '1-3-stable'

gem 'spree_payone_frontend', :git => 'git://github.com/hefan/spree_payone_frontend.git',                :branch => '1-3-stable'
#gem 'spree_payone_frontend', :git => 'git://github.com/meinekleinefarm/spree_payone_frontend.git',     :branch => '1-3-stable'

#gem 'spree_snowplow',          :git => 'git://github.com/meinekleinefarm/spree_snowplow.git',           :branch => 'master'

gem 'spree_sitemap',            github: 'jdutil/spree_sitemap', branch: '1-3-stable'
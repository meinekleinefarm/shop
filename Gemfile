source 'https://rubygems.org'


group :default do

  gem 'rails', '3.2.13'

  # Bundle edge Rails instead:
  # gem 'rails', :git => 'git://github.com/rails/rails.git'
  gem 'haml'

  # Use unicorn as the app server
  gem 'unicorn'

  # gem 'mysql2'
  gem 'pg'
  gem 'jquery-rails' #, '~> 2.1.4'
  gem 'tinymce-rails'
  gem 'tinymce-rails-langs'
  gem 'memcache-client'
  # gem 'airbrake'
  gem 'i18n'
  gem 'rails-i18n'
  gem 'rack-statsd'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails', '3.6.0'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'guard-rspec'
  gem 'guard-spork'

end

group :development do
  gem 'ruby-graphviz'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'


group :deployment do
  # Deploy with Capistrano
  gem 'capistrano'
end


# To use debugger
# gem 'debugger'
gem 'spree', '1.3.3'
gem 'spree_gateway',            :git => 'git://github.com/spree/spree_gateway',                       :branch => '1-3-stable'
gem 'spree_auth_devise',        :git => 'git://github.com/spree/spree_auth_devise',                   :branch => '1-3-stable'
gem 'spree_i18n',               :git => 'git://github.com/spree/spree_i18n.git',                      :branch => '1-3-stable'
gem 'spree_paypal_express',     :git => 'git://github.com/spree/spree_paypal_express.git',            :branch => '1-3-stable'
gem 'spree_reviews',            :git => 'git://github.com/spree/spree_reviews.git',                   :branch => '1-3-stable'
gem 'spree_editor',             :git => 'git://github.com/spree/spree_editor.git',                    :branch => '1-3-stable'
gem 'spree_contact_us',         :git => 'git://github.com/jdutil/spree_contact_us.git',               :branch => '1-3-stable'
gem 'spree_social_products',    :git => 'git://github.com/spree/spree_social_products.git',           :branch => '1-3-stable'

gem 'spree_essentials',         :git => 'git://github.com/coupling/spree_essentials',                 :branch => '1-3-stable'
gem 'spree_essential_cms',      :git => 'git://github.com/coupling/spree_essential_cms',              :branch => '1-3-stable'
gem 'spree_essential_blog',     :git => 'git://github.com/meinekleinefarm/spree_essential_blog',      :branch => '1-3-stable'
#gem 'spree_essential_blog',             :path => '../spree_essential_blog'



gem 'spree_essential_menus',    :git => 'git://github.com/meinekleinefarm/spree_essential_menus.git'
#gem 'spree_essential_menus',    :path => '../spree_essential_menus'

gem 'spree_bank_transfer',      :git => 'git://github.com/meinekleinefarm/spree-bank-transfer',       :branch => 'master'
#gem 'spree_bank_transfer',      :path => '../spree-bank-transfer'

gem 'spree_mkf_theme',          :git => 'git://github.com/meinekleinefarm/spree_mkf_theme',           :branch => 'master'
#gem 'spree_mkf_theme',          :path => '../spree_mkf_theme'

gem 'spree_export',             :git => 'git://github.com/meinekleinefarm/spree_export.git'
#gem 'spree_export',             :path => '../spree_export'

gem 'spree_advanced_reporting', :git => 'git://github.com/meinekleinefarm/spree_advanced_reporting.git',  :branch => '1-3-stable'
#gem 'spree_advanced_reporting', :path => '../spree_advanced_reporting'
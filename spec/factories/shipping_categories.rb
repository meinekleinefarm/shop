# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping_category, :class => 'Spree::ShippingCategory' do
    name 'Standardversand'
  end
end

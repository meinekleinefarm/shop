# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address, :class => 'Spree::Address' do

    firstname 'Chris'
    lastname 'Tucker'
    city 'New York'
    zipcode '55555'
    association :country, factory: :germany
  end
end

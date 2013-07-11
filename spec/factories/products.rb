# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product, :class => 'Spree::Product' do
    name 'Leberwurst'
    description 'Allerfeinste Leberwurst mit Zwiebel und Speck'
    available_on { 10.days.ago }
    permalink 'leberwurst'
    association :tax_category, factory: :reduced_tax_category
    price 4.0
    shipping_category
    on_demand false
    
    after :create do |product|
      product.master.images = [ FactoryGirl.create(:image)]
    end
  end
end

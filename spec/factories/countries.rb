# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :country, :class => 'Spree::Country' do
    
    factory :germany do
      iso_name 'Deutschland'
      iso 'de'
      iso_3 'ger'
      name 'Deutschland'
      states_required false
    end
  end
end

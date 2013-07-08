# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role, :class => 'Spree::Role' do
    
    factory :admin_role do
      name 'admin'
    end
  end
end

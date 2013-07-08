#encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tax_category, :class => 'Spree::TaxCategory' do
    
    name 'Regelsteuersatz'
    description 'Grundsätzlich unterliegen Umsätze dem vollen Umsatzsteuersatz von 19%'
    
    factory :reduced_tax_category do
      name 'Mindersteuersatz'
      description 'Bestimmte Umsätze sind begünstigt durch den ermäßigten Steuersatz von 7%'
    end
  end
end

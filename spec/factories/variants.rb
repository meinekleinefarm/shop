# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variant, :class => 'Spree::Variant' do
    images { [ FactoryGirl.create(:image)] }

    factory :master do
      is_master true
    end

  end
end

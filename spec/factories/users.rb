# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, :class => 'Spree::User' do
    email "user@example.com"
    password "verysecretpassword"
    password_confirmation "verysecretpassword"

    factory :admin do
      spree_roles { [FactoryGirl.create(:admin_role)] }
    end
  end
end

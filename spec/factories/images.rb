# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :image, :class => 'Spree::Image' do
    attachment { fixture_file_upload('spec/fixtures/jagdwurst.jpg', 'image/jpg') }
  end
end

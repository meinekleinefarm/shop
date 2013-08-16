FactoryGirl.define do
  factory :completed_order_with_items, :class => Spree::Order do
    bill_address { FactoryGirl.create(:address) }
    ship_address { FactoryGirl.create(:address) }
    state 'complete'
    completed_at Time.now

    after :create do |order|
      5.times do |i|
        FactoryGirl.create(:line_item, :order => subject)
        FactoryGirl.create(:inventory_unit, :order => order, :state => 'shipped')
      end
    end
  end
end
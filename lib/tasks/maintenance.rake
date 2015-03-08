namespace :maintenance do

  desc 'Connect guest orders with known emails'
  task connect_orders: :environment do
    Spree::Order.complete.where(user_id: nil).find_each do |order|
      if user = Spree::User.find_by_email(order.email)
        order.user = user
        order.save!(validate: false)
      end
    end
  end
end
namespace :maintenance do

  namespace :orders do

    task assign_users: :environment do
      Spree::Order.complete.where(user_id: nil).find_each do |order|
        if existing_user = Spree::User.find_by_email(order.email)
          puts "Found user #{existing_user.id} for order #{order.number}."
          Spree::Order.where(id: order.id).update_all(user_id: existing_user.id)
        end
      end
    end
  end
end
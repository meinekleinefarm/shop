namespace :payments do

  task check_pending: :environment do
    start_date = 14.days.ago.beginning_of_day
    end_date = 7.days.ago.beginning_of_day

    involved_orders(start_date, end_date).each do |order|
      begin
        #puts order.inspect
        PaymentMailer.warning(order).deliver
      rescue Exception => e
        Rails.logger.warn("Could not deliver email for order #{order.number}: #{e.message}")
      end
    end
  end

  task cancel_overdue: :environment do
    start_date = Time.at(0)
    end_date = 15.days.ago.end_of_day

    involved_orders(start_date, end_date).each do |order|
      puts order.inspect
      puts order.payments.inspect
      # order.cancel!
    end
  end

  task inform_shop: :environment do
    start_date = Time.at(0)
    end_date = 7.days.ago.end_of_day
    payment_method_types = Spree::PaymentMethod.where('type <> ?', 'Spree::PaymentMethod::BankTransfer').pluck(:type).uniq
    orders = involved_orders(start_date, end_date, payment_method_types)
    PaymentMailer.inform_shop(orders).deliver
  end

  def involved_orders(start_date, end_date, payment_method_types = ['Spree::PaymentMethod::BankTransfer'])
    payment_method_ids = Spree::PaymentMethod.where(type: payment_method_types).pluck(:id).uniq
    invalid_states = [ :invalid, :failed ]
    Spree::Order.
      complete.
      where(completed_at: (start_date..end_date)).
      where(payment_state: :balance_due).
      joins(:payments).
      where('spree_payments.state NOT IN (?)', invalid_states).
      where(:'spree_payments.payment_method_id' => payment_method_ids)
  end

end
namespace :payments do

  desc 'Vorauskasse, älter als 7 Tage'
  task check_pending: :environment do
    start_date = 8.days.ago.beginning_of_day
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

  desc 'Vorauskasse, älter als 14 Tage'
  task inform_cancel: :environment do
    start_date = Date.parse(ENV["START_DATE"]).beginning_of_day if ENV["START_DATE"]
    start_date ||= 21.days.ago.beginning_of_day
    puts start_date.inspect

    end_date = Date.parse(ENV["END_DATE"]).beginning_of_day if ENV["END_DATE"]
    end_date ||= 14.days.ago.beginning_of_day
    puts end_date.inspect

    orders = involved_orders(start_date, end_date)
    PaymentMailer.inform_cancel(orders).deliver
  end

  desc 'Keine Vorauskasse, älter als 7 Tage'
  task inform_shop: :environment do
    start_date = Time.at(0)
    end_date = 7.days.ago.beginning_of_day
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
      where(state: "complete").
      where(payment_state: :balance_due).
      joins(:payments).
      where('spree_payments.state NOT IN (?)', invalid_states).
      where(:'spree_payments.payment_method_id' => payment_method_ids)
  end

end
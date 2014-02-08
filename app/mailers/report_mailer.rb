# encoding: UTF-8
class ReportMailer < ActionMailer::Base
  default :from => "shop@meinekleinefarm.org"

  def weekly(user, start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    @visitors = []
    @visitors << visitors(start_date, end_date)
    @visitors << visitors(beginning_of_week_before(start_date), end_of_week_before(end_date))

    @visitors_by_source = visitors_by_source(start_date, end_date)

    @revenue = []
    @revenue << revenue(start_date, end_date)
    @revenue << revenue(beginning_of_week_before(start_date), end_of_week_before(end_date))

    @abandoned = []
    @abandoned << abandoned(start_date, end_date)
    @abandoned << abandoned(beginning_of_week_before(start_date), end_of_week_before(end_date))

    @payments = []
    @payments << payments(start_date, end_date)
    @payments << payments(beginning_of_week_before(start_date), end_of_week_before(end_date))
    @payments.compact!

    mail( :to => user.email,
          :reply_to => "cb@meinekleinefarm.de",
          :subject => "MkF: Weekly Report"
        )
  end



  def beginning_of_week_before(start_date)
    start_date - 7.days
  end

  def end_of_week_before(end_date)
    end_date - 7.days
  end

  def visitors(start_date, end_date)
    results = GATTICA_INSTANCE.get({
                        :start_date => start_date.to_s,
                        :end_date => end_date.to_s,
                        :metrics => ['visitors'],
                      }).to_hash

    results.first[:visitors].to_i
  end

  def visitors_by_source(start_date, end_date)
    results = GATTICA_INSTANCE.get({
                        :start_date => start_date.to_s,
                        :end_date => end_date.to_s,
                        :dimensions => ['source'],
                        :metrics => ['visitors'],
                        :sort => ['-visitors'],
                      }).to_hash

    results[0...5]
  end

  def revenue(start_date, end_date)
    results = Spree::Order.search( completed_at_gt: start_date.beginning_of_day,
                            completed_at_lt: end_date.end_of_day).result
    results.sum(:item_total)
  end

  def abandoned(start_date, end_date)
    created   = Spree::Order.search( created_at_gt: start_date.beginning_of_day,
                            created_at_lt: end_date.end_of_day).result.count
    completed = Spree::Order.search( completed_at_gt: start_date.beginning_of_day,
                            completed_at_lt: end_date.end_of_day).result.count

    abandoned_carts = created - completed
    rate = (abandoned_carts * 100 / created) rescue 100
    { created: created, completed: completed, abandoned: abandoned_carts, rate: rate }

  end

  def payments(start_date, end_date)
    search = Spree::Payment.search( created_at_gt: start_date.beginning_of_day,
                                created_at_lt: end_date.end_of_day).result
    payments_hash = search.group(:payment_method_id).count
    payments_hash.keys.each do |k|
      payment_name = Spree::PaymentMethod.find(k).name
      payments_hash[payment_name] = payments_hash.delete(k)
    end
    payments_hash unless payments_hash.blank?
  end

end

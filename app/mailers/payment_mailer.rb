# encoding: UTF-8
class PaymentMailer < ActionMailer::Base
  default :from => "shop@meinekleinefarm.org"

  def warning(order)
    @order = order
    mail( :to => @order.email,
          :reply_to => "shop@meinekleinefarm.de",
          :subject => "Fleisch mit Gesicht: Vergessen, zu bezahlen?"
        )
  end

  def inform_shop(orders)
    @orders = orders
    mail( :to => "shop@meinekleinefarm.org",
          :reply_to => "cb@meinekleinefarm.de",
          :subject => "Bestellungen älter als 7 Tage - keine Vorauskasse"
        )
  end

  def inform_cancel(orders)
    @orders = orders
    mail( :to => "shop@meinekleinefarm.org",
          :reply_to => "cb@meinekleinefarm.de",
          :subject => "Vorauskasse: Bestellungen älter als 14 Tage"
        )
  end
end

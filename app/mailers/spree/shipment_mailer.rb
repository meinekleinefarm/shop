module Spree
  class ShipmentMailer < ActionMailer::Base
    helper 'spree/base'

    def shipped_email(shipment, resend = false)
      @shipment = shipment
      subject = (resend ? "[#{t(:resend).upcase}] " : '')
      subject += "#{Spree::Config[:site_name]} #{t('shipment_mailer.shipped_email.subject')}"
      mail(:to => shipment.order.email,
           :subject => subject)
    end
  end
end

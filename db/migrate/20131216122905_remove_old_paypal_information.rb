class RemoveOldPaypalInformation < ActiveRecord::Migration
  def up
    Spree::PaymentMethod.where(type: 'Spree::BillingIntegration::PaypalExpress').destroy_all
  end

  def down
  end
end

# This migration comes from spree_bank_transfer (originally 20130327193040)
class AddPaymentConfirmedToSpreeOrders < ActiveRecord::Migration
  def change
    change_table :spree_orders do |t|
      t.boolean :payment_confirmed
    end
  end
end

# This migration comes from spree_sofort (originally 20140527171300)
class AddSofortTransactionToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sofort_transaction, :string
  end
end

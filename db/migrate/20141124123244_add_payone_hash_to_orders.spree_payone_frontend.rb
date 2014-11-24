# This migration comes from spree_payone_frontend (originally 20140214014700)
class AddPayoneHashToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :payone_hash, :string
  end
end

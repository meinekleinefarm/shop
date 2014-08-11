# This migration comes from spree_sofort (originally 20140528040000)
class AddSofortLogToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sofort_log, :text
  end
end

# This migration comes from spree_sofort (originally 20140522181100)
class AddSofortHashToOrders < ActiveRecord::Migration

  def change
    add_column :spree_orders, :sofort_hash, :string
  end

end

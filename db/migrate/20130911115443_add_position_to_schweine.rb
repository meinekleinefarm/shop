class AddPositionToSchweine < ActiveRecord::Migration
  def up
    add_column :spree_schweine, :position, :integer, :default => 0, :null => false
  end

  def down
    remove_column :spree_schweine, :position
  end
end

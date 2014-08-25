# This migration comes from spree_mkf_theme (originally 20140825084221)
class AddInitiallyOnHand < ActiveRecord::Migration
  def up
    add_column :spree_variants, :initial_count_on_hand, :integer, default: 0
  end

  def down
    remove_column :spree_variants, :initial_count_on_hand
  end
end

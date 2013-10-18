# This migration comes from spree_essential_blog (originally 20120306185710)
class CreatePostCategories < ActiveRecord::Migration
  def self.up
    create_table :post_categories, :force => true do |t|
      t.string :name
      t.string :permalink
      t.timestamps
    end
  end

  def self.down
    drop_table :post_categories
  end
end

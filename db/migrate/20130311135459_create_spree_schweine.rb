class CreateSpreeSchweine < ActiveRecord::Migration
  def change
    create_table :spree_schweine do |t|
      t.string :name
      t.text :description
      t.date :date_of_death
      t.integer :weight
      t.string :meta_keywords
      t.string :meta_description
      t.timestamps
    end
  end
end

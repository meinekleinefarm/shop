# This migration comes from spree_bank_transfer (originally 20130326155838)
class CreateSpreeBankAccounts < ActiveRecord::Migration
  def change
    create_table :spree_bank_accounts do |t|
    	t.string :bank_name
    	t.string :bank_branch
    	t.string :account_owner
    	t.string :account_number
      t.timestamps
    end
  end
end

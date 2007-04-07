require 'migration_helpers'

class CreateBudgetAccounts < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :budget_accounts do |t|
			t.column "budget_id",   :integer
			t.column "account_id",  :integer
			t.column "sum", 	      :decimal, :precision => 15, :scale => 2
    end
    
		foreign_key(:budget_accounts, :budget_id, :budgets)
		foreign_key(:budget_accounts, :account_id, :accounts)
  end

  def self.down
#		drop_foreign_key(:budget_accounts, :budget_id, :budgets)
#		drop_foreign_key(:budget_accounts, :account_id, :accounts)

    drop_table :budget_accounts
  end
end

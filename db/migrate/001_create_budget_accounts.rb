class CreateBudgetAccounts < ActiveRecord::Migration
  def self.up
    create_table :budget_accounts do |t|
    end
  end

  def self.down
    drop_table :budget_accounts
  end
end

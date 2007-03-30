require 'migration_helpers'

class CreateAccounts < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :accounts do |t|
      t.column "name",              :string
      t.column "fiscal_period_id",  :integer
      t.column "number",            :integer
      t.column "description",       :string
      t.column "type_id",           :integer
      t.column "parent_id",         :integer
    end

		foreign_key(:accounts, :fiscal_period_id, :fiscal_periods)
		foreign_key(:accounts, :parent_id, :accounts)
		foreign_key(:accounts, :type_id, :account_types)

  end

  def self.down
		drop_foreign_key(:accounts, :fiscal_period_id, :fiscal_periods)
		drop_foreign_key(:accounts, :parent_id, :accounts)
		drop_foreign_key(:accounts, :type_id, :account_types)
    drop_table :accounts
  end
end

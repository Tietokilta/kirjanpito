require 'migration_helpers'

class CreateBudgets < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :budgets do |t|
			t.column "fiscal_period_id", :integer
			t.column "description", :string
    end

		foreign_key(:budgets, :fiscal_period_id, :fiscal_periods)
  end

  def self.down
#		drop_foreign_key(:budgets, :fiscal_period_id, :fiscal_periods)

    drop_table :budgets
  end
end

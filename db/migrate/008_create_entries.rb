require 'migration_helpers'

class CreateEntries < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :entries, :options => "DEFAULT CHARSET=utf8"  do |t|
			t.column "receipt_number",    :integer
			t.column "description",    :string
			t.column "sum",    :decimal, :precision => 15, :scale => 2
			t.column "date",    :date
			t.column "fiscal_period_id",    :integer
			t.column "debet_account_id",    :integer
			t.column "credit_account_id",    :integer
    end

		foreign_key(:entries, :fiscal_period_id, :fiscal_periods);
		foreign_key(:entries, :debet_account_id, :accounts);
		foreign_key(:entries, :credit_account_id, :accounts);
  end

  def self.down
#		drop_foreign_key(:entries, :fiscal_period_id, :fiscal_periods);
#		drop_foreign_key(:entries, :debet_account_id, :accounts);
#		drop_foreign_key(:entries, :credit_account_id, :accounts);
		
    drop_table :entries
  end
end

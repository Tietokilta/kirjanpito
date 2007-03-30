require 'migration_helpers'

class CreateInvoices < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :invoices do |t|
			t.column "date", :date
			t.column "fiscal_period_id", :integer
			t.column "description", :string
			t.column "sum", :decimal, :precision => 15, :scale => 2
			t.column "payer", :string
			t.column "payer_contact", :string
			# TODO: add more fields as required

			t.column "target_account_id", :integer
			t.column "paymentdate", :date
			t.column "source_account_id", :integer
    end
		foreign_key(:invoices, :fiscal_period_id, :fiscal_periods)
		foreign_key(:invoices, :target_account_id, :accounts)
		foreign_key(:invoices, :source_account_id, :accounts)
		
  end

  def self.down
		drop_foreign_key(:invoices, :fiscal_period_id, :fiscal_periods)
		drop_foreign_key(:invoices, :target_account_id, :accounts)
		drop_foreign_key(:invoices, :source_account_id, :accounts)
    drop_table :invoices
  end
end
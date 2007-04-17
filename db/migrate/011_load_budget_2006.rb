require 'active_record/fixtures'

class LoadBudget2006 < ActiveRecord::Migration
  def self.up
		down

		dir = File.join(File.dirname(__FILE__), "budget_2006")
		Fixtures.create_fixtures(dir, "account_types")
		Fixtures.create_fixtures(dir, "fiscal_periods")

		#execute "LOCK TABLES `accounts` WRITE;"
		#execute "ALTER TABLE `accounts` DISABLE KEYS;"
		execute "SET FOREIGN_KEY_CHECKS=0"
		Fixtures.create_fixtures(dir, "accounts")
		execute "SET FOREIGN_KEY_CHECKS=1"
		#execute "ALTER TABLE `accounts` ENABLE KEYS;"
		#execute "UNLOCK TABLES;"

		Fixtures.create_fixtures(dir, "entries")
  end

  def self.down
		Entry.delete_all
		Account.delete_all
		AccountType.delete_all
		Budget.delete_all
		FiscalPeriod.delete_all
  end
end
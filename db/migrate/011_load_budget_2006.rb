require 'active_record/fixtures'

class LoadBudget2006 < ActiveRecord::Migration
  def self.up
		#down

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
		Fixtures.create_fixtures(dir, "budgets")
		Fixtures.create_fixtures(dir, "budget_accounts")
  end

  def self.down
		Entry.delete(Entry.find(:all, :conditions => 'fiscal_period_id = 2006'))
		Account.delete(Account.find(:all, :conditions => 'fiscal_period_id = 2006'))
		AccountType.delete_all
		BudgetAccount.delete(BudgetAccount.find(:all, :conditions => 'budget_id in (200601, 200602)'))
		Budget.delete(Budget.find(:all, :conditions => 'fiscal_period_id = 2006'))
		FiscalPeriod.delete(FiscalPeriod.find(:all, :conditions => 'id = 2006'))
  end
end

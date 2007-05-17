require 'active_record/fixtures'

class LoadBudget2007 < ActiveRecord::Migration

	def self.insertfixtures(dir, table) 
		Fixtures.new(ActiveRecord::Base.connection, table, nil, File.join(dir, table)).insert_fixtures
	end

  def self.up
		#down
		

		dir = File.join(File.dirname(__FILE__), "budget_2007")
		#Already defined in 2006
		#Fixtures.create_fixtures(dir, "account_types")
		#Fixtures.create_fixtures(dir, "fiscal_periods")
		#Huoh... create_fixtures deletes all old data

		insertfixtures(dir, "fiscal_periods")


		#execute "LOCK TABLES `accounts` WRITE;"
		#execute "ALTER TABLE `accounts` DISABLE KEYS;"
		execute "SET FOREIGN_KEY_CHECKS=0"
		insertfixtures(dir, "accounts")
		execute "SET FOREIGN_KEY_CHECKS=1"
		#execute "ALTER TABLE `accounts` ENABLE KEYS;"
		#execute "UNLOCK TABLES;"

		#not yet there
		#Fixtures.create_fixtures(dir, "entries")
		
		#Copy current data
		#execute "INSERT INTO entries (receipt_number, description, sum, date, fiscal_period_id, debet_account_id, credit_account_id) SELECT at.number, explanation, sum, date, 2007, 20070000+ad.number, 20070000+ak.number FROM xaccount_transactions at INNER JOIN xaccounts ad ON at.debet = ad.id INNER JOIN xaccounts ak ON at.kredit = ak.id"
		
		insertfixtures(dir, "budgets")
		insertfixtures(dir, "budget_accounts")
  end

  def self.down
		#Entry.delete(Entry.find(:all, :conditions => 'fiscal_period_id = 2007'))
		Account.delete(Account.find(:all, :conditions => 'fiscal_period_id = 2007'))
		BudgetAccount.delete(BudgetAccount.find(:all, :conditions => 'budget_id = 200701'))
		Budget.delete(Budget.find(:all, :conditions => 'fiscal_period_id = 2007'))
		FiscalPeriod.delete(FiscalPeriod.find(2007))
  end
end

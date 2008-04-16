class Entry < ActiveRecord::Base
  belongs_to  :fiscal_period
  belongs_to  :debet_account,
							:class_name => "Account",
							:foreign_key => "debet_account_id"
  belongs_to  :credit_account,
							:class_name => "Account",
							:foreign_key => "credit_account_id"

	def self.getbalances(fiscal_period_id, startdate, enddate)


		cond = ['fiscal_period_id = ? AND date BETWEEN ? AND ?', fiscal_period_id, startdate, enddate] if startdate and enddate
		
		cond ||=  ['fiscal_period_id = ?', fiscal_period_id]

		debs = Entry.find(:all, :select => 'debet_account_id, sum(sum) as balance', :group => 'debet_account_id', :conditions => cond)
		creds = Entry.find(:all, :select => 'credit_account_id, sum(sum) as balance', :group => 'credit_account_id', :conditions => cond)

		accounts = Hash.new
		
    debs.each {|acc|
			accounts[acc.debet_account_id] = 0.0 unless accounts[acc.debet_account_id]
			accounts[acc.debet_account_id] -= acc.balance.to_f
		}
    creds.each {|acc|
			accounts[acc.credit_account_id] = 0.0 unless accounts[acc.credit_account_id]
			accounts[acc.credit_account_id] += acc.balance.to_f
		}
		return accounts
	end
end

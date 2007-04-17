require 'migration_helpers'

class AddDefaultData < ActiveRecord::Migration
  def self.up
		at = AccountType.create(:description => "Tulos")
		at.save!
		
		at = AccountType.create(:description => "Tase")
		at.save!

		fp = FiscalPeriod.create(:startdate => "2006-01-01", :enddate => "2006-12-31")
		fp.save!
		fp = FiscalPeriod.create(:startdate => "2007-01-01", :enddate => "2007-12-31")
		fp.save!


  end

  def self.down
		AccountType.delete(AccountType.find(:all, :conditions => ["description in (?)", ["Tulos", "Tase"] ]))
		
		FiscalPeriod.delete(FiscalPeriod.find(:all, :conditions => ["startdate in (?)", ["2006-01-01", "2007-01-01"] ]))
  end
end


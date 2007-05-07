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

    user = User.new()
    user.login = "rahis"
    user.password = "pahis"
    user.password_confirmation = "pahis"
    user.email = "lholsti@niksula.hut.fi"
    user.level = 2
    user.save!


  end

  def self.down
    User.delete(User.find(:all, :conditions => ["login in (?)", ["rahis"] ]))
		AccountType.delete(AccountType.find(:all, :conditions => ["description in (?)", ["Tulos", "Tase"] ]))
		FiscalPeriod.delete(FiscalPeriod.find(:all, :conditions => ["startdate in (?)", ["2006-01-01", "2007-01-01"] ]))
  end
end


require 'migration_helpers'

class CreateFiscalPeriods < ActiveRecord::Migration
  def self.up
    create_table :fiscal_periods do |t|
			t.column "startdate", :date
			t.column "enddate", :date
    end
  end

  def self.down
    drop_table :fiscal_periods
  end
end

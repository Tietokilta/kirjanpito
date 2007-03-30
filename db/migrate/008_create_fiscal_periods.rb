class CreateFiscalPeriods < ActiveRecord::Migration
  def self.up
    create_table :fiscal_periods do |t|
    end
  end

  def self.down
    drop_table :fiscal_periods
  end
end

class FiscalPeriod < ActiveRecord::Base
  has_many  :entries
  has_many  :budgets
  has_many  :accounts
  has_many  :invoices
  
  def to_s
#    return "#{self.startdate} - #{self.enddate}"
    return "#{self.id}"
  end
end

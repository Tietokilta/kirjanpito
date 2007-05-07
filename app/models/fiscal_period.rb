class FiscalPeriod < ActiveRecord::Base
  has_many  :entries #, :as => :addressable
  has_many  :budgets
  has_many  :accounts
  has_many  :invoices
  
  def time_frame
    return "#{self.startdate} - #{self.enddate}"
  end

	def to_label
#    "#{self.city} #{self.state}, #{self.zip}"
		"#{self.id}"
  end
end

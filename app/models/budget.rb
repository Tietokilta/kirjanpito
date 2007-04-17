class Budget < ActiveRecord::Base
  has_many    :budget_accounts

  belongs_to  :fiscal_period
	
	
	validates_presence_of :description, :fiscal_period_id
  

	def validate
		errors.add_to_base('The given fiscal period does not exist.') if fiscal_period_id.nil?
	end



end

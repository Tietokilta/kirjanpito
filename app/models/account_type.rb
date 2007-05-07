class AccountType < ActiveRecord::Base
  has_many  :accounts
	
	def to_label
		"#{self.description}"
	end
end

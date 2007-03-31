class Budget < ActiveRecord::Base
  has_many    :budget_accounts

  belongs_to  :fiscal_period
  
end

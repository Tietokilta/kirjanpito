class BudgetAccount < ActiveRecord::Base
  belongs_to  :account
  belongs_to  :budget
end

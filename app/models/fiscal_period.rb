class FiscalPeriod < ActiveRecord::Base
  has_many  :entries
  has_many  :budgets
  has_many  :accounts
  has_many  :invoices
end

class Account < ActiveRecord::Base
  acts_as_tree  :order => "number"

  has_and_belongs_to_many :users
  
  has_many    :budget_accounts
  has_many    :debet_entries,
              :class_name   => "entry"
  has_many    :kredit_entries,
              :class_name   => "entry"
  has_many    :source_invoice,
              :class_name   => "invoice"
  has_many    :target_invoice,
              :class_name   => "invoice"

  belongs_to  :fiscal_period
  belongs_to  :account
  belongs_to  :account_type

end

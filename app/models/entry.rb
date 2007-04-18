class Entry < ActiveRecord::Base
  belongs_to  :fiscal_period
  belongs_to  :debet_account,
							:class_name => "Account",
              :foreign_key  => "debet_account_id"
  belongs_to  :credit_account,
							:class_name => "Account",
              :foreign_key  => "credit_account_id"
end

class Invoice < ActiveRecord::Base
  belongs_to  :fiscal_period
  belongs_to  :source_account,
              :foreign_key  => "fk_invoices_source_account_id"
  belongs_to  :target_account,
              :foreign_key  => "fk_invoices_target_account_id"
end

class Entry < ActiveRecord::Base
  belongs_to  :fiscal_period
  belongs_to  :debet_account,
              :foreign_key  => "fk_entries_debet_account_id"
  belongs_to  :kredit_account,
              :foreign_key  => "fk_entries_kredit_account_id"
end

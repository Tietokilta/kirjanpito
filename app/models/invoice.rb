class Invoice < ActiveRecord::Base
  belongs_to  :fiscal_period
  belongs_to  :source_account,
							:class_name => "Account",
              :foreign_key  => "source_account_id"
  belongs_to  :target_account,
							:class_name => "Account",
              :foreign_key  => "target_account_id"
              
#  before_validation :fix_decimal_separator

  validates_presence_of :description, :fiscal_period_id, :type_id, :payer
  validates_numericality_of :sum
  
#  def fix_decimal_separator
#    logger.info self.sum
#    self.sum = self.sum.to_s.gsub(/,/, '.').to_f
#  end
end

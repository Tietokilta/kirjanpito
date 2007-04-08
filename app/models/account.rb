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

  validates_presence_of :name, :fiscal_period_id, :type_id
  validates_numericality_of :number, :only_integer => true, 
    :message => " must be an integer."
#  validates_uniqueness_of :number, :scope => "fiscal_period_id"

  def validate
    errors.add_to_base('The given fiscal period does not exist.') if fiscal_period_id.nil?
  end 

  def smallest_child
    return Account.minimum("number", :conditions => ['parent_id = ?', self.id])
  end

end

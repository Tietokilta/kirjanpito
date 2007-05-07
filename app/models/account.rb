class Account < ActiveRecord::Base
  acts_as_tree  :order => "number"

  has_and_belongs_to_many :users
  
  has_many    :budget_accounts
  has_many    :debet_entries, :class_name   => "entry"
  has_many    :credit_entries, :class_name   => "entry"
  has_many    :source_invoice, :class_name   => "invoice"
  has_many    :target_invoice, :class_name   => "invoice"

  has_and_belongs_to_many :account

  belongs_to  :fiscal_period
  belongs_to  :account_type, :foreign_key => "type_id"

  validates_presence_of :name, :fiscal_period_id, :type_id
#  validates_numericality_of :number, :only_integer => true, 
#    :message => " must be an integer."
  validates_uniqueness_of :number, :scope => "fiscal_period_id"

  def validate
    errors.add_to_base('The given fiscal period does not exist.') if fiscal_period_id.nil?
  end 

  def smallest_child
    sc = Account.minimum("number", :conditions => ['parent_id = ?', self.id])
    if !sc
      sc = 10000;
    end
    return sc
  end

	def balance
		bal = 0
		Entry.find(:all, :conditions => ['credit_account_id = ? OR debet_account_id = ?', self.id, self.id]).each { |e|
			if (e.credit_account_id == self.id)
				bal += e.sum
			else
				bal -= e.sum
			end
		}

		return bal
	end

	def parent_account
    Account.find(:first, :conditions => ['name LIKE ?', params[:account][:parent_id][5..-1]])
	end

	def to_s
		return number.to_s + " " + name
	end

	def to_label
		return "%04d" % self.number + " " + self.name
	end
end

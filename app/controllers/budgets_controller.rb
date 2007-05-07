class BudgetsController < ApplicationController
	active_scaffold :budget do |config|
		config.columns = [:fiscal_period, :description]
	end

#   def index
#     list
#     render :action => 'list'
#   end
# 
#   # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#   verify :method => :post, :only => [ :destroy, :create, :update ],
#          :redirect_to => { :action => :list }
# 
#   def list
#     @budget_pages, @budgets = paginate :budgets, :per_page => 10, :order => :fiscal_period_id, :order => :description
#   end
# 
#   def show
#     @budget = Budget.find(params[:id])
#   end
# 
#   def new
#     @budget = Budget.new
#   end
# 
#   def create
#     @dates = params[:budget][:fiscal_period_id].split(" - ")
#     @dates[0] = Date.strptime(@dates[0], "%d.%m.%Y")
#     @dates[1] = Date.strptime(@dates[1], "%d.%m.%Y")
#     @fiscal_period_id = FiscalPeriod.find(:first,
#       :conditions => ['startdate LIKE ? AND enddate LIKE ?', @dates[0], @dates[1] ])
#     if @fiscal_period_id
#       @fiscal_period_id = @fiscal_period_id.id
#     end
# 
#     @budget = Budget.new(params[:budget])
# 		@budget.fiscal_period_id = @fiscal_period_id
# 
#     if @budget.save
#       flash[:notice] = 'Budget was successfully created.'
#       redirect_to :action => 'list'
#     else
#       render :action => 'new'
#     end
#   end
# 
#   def edit
#     @budget = Budget.find(params[:id])
#     @fiscal_period = FiscalPeriod.find(@budget[:fiscal_period_id]) unless @budget[:fiscal_period_id].nil?
#   end
#   
# 	def update_accounts
#     @budget = Budget.find(params[:id])
# 
# 		BudgetAccount.delete(BudgetAccount.find(:all, :conditions => ['budget_id = ?', @budget.id]))
# 
# 
# 		params[:budgetaccounts].each { |x|
# 				ba = BudgetAccount.new
# 				ba.budget_id = @budget.id
# 				ba.account_id = x[0]
# 				ba.sum = params[:accountsum][x[0].to_s]
# 				ba.save!
# 		}
# 
# 		render :action => 'show'
# 	end
# 
#   def update
#     @budget = Budget.find(params[:id])
#     @dates = params[:budget][:fiscal_period_id].split(" - ")
#     @dates[0] = Date.strptime(@dates[0], "%d.%m.%Y")
#     @dates[1] = Date.strptime(@dates[1], "%d.%m.%Y")
#     @fiscal_period_id = FiscalPeriod.find(:first,
#       :conditions => ['startdate LIKE ? AND enddate LIKE ?', @dates[0], @dates[1] ])
#     if @fiscal_period_id
#       @fiscal_period_id = @fiscal_period_id.id
#     end
# 		params[:budget][:fiscal_period_id] = @fiscal_period_id
# 
#     if @budget.update_attributes(params[:budget])
#       flash[:notice] = 'Budget was successfully updated.'
#       redirect_to :action => 'show', :id => @budget
#     else
#       render :action => 'edit'
#     end
#   end
# 
#   def destroy
#     Budget.find(params[:id]).destroy
#     redirect_to :action => 'list'
#   end
#   
# 	def autocomplete_fiscal_period_id
#       @fiscal_period_ids = FiscalPeriod.find(:all,
#         :conditions => [ 'startdate LIKE ? OR enddate LIKE ?', '%'+params[:budget][:fiscal_period_id]+'%', '%'+params[:budget][:fiscal_period_id]+'%'] )
#       @fiscal_period_id = params[:budget][:fiscal_period_id]
#       render :layout => false
#   end


end

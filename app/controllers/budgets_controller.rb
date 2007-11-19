class BudgetsController < ApplicationController
	before_filter :pages
	def pages
		@pages = {
			'list' => "Budjetit"
			}
	end

  def index
    redirect_to :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @budget_pages, @budgets = paginate :budgets, :per_page => 10, :order => "fiscal_period_id asc, description"
  end

  def show
    @budget = Budget.find(params[:id])
  end

  def new
    @budget = Budget.new
		@budget.fiscal_period_id = session[:fiscal_period_id]

  end

  def create
    @budget = Budget.new(params[:budget])

    if @budget.save
      flash[:notice] = 'Budget was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @budget = Budget.find(params[:id])
  end
  
	def update_accounts
    @budget = Budget.find(params[:id])

		BudgetAccount.delete(BudgetAccount.find(:all, :conditions => ['budget_id = ?', @budget.id]))

		params[:budgetaccounts].each { |x|
				ba = BudgetAccount.new
				ba.budget_id = @budget.id
				ba.account_id = x[0]
				ba.sum = params[:accountsum][x[0].to_s].tr ",", "."
				ba.save!
		}

		render :action => 'show'
	end

  def update
    @budget = Budget.find(params[:id])

    if @budget.update_attributes(params[:budget])
      flash[:notice] = 'Budget was successfully updated.'
      redirect_to :action => 'show', :id => @budget
    else
      render :action => 'edit'
    end
  end

  def destroy
    Budget.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
end

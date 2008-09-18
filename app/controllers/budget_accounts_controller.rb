class BudgetAccountsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @budget_accounts = BudgetAccount.paginate :page => params[:page], :per_page => 10
  end

  def show
    @budget_account = BudgetAccount.find(params[:id])
  end

  def new
    @budget_account = BudgetAccount.new
  end

  def create
    @budget_account = BudgetAccount.new(params[:budget_account])
    if @budget_account.save
      flash[:notice] = 'BudgetAccount was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @budget_account = BudgetAccount.find(params[:id])
  end

  def update
    @budget_account = BudgetAccount.find(params[:id])
    if @budget_account.update_attributes(params[:budget_account])
      flash[:notice] = 'BudgetAccount was successfully updated.'
      redirect_to :action => 'show', :id => @budget_account
    else
      render :action => 'edit'
    end
  end

  def destroy
    BudgetAccount.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

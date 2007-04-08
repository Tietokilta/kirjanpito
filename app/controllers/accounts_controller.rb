class AccountsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @accounts = Account.find(:all, :order => "parent_id")
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
  end

  def create
    @dates = params[:account][:fiscal_period_id].split(" - ")
    @fiscal_period = FiscalPeriod.find(:first,
      :conditions => ['startdate LIKE ? AND enddate LIKE ?', @dates[0], @dates[1] ])
    if @fiscal_period
      @fiscal_period = @fiscal_period.id
    end

    @type = AccountType.find(:first, :conditions => ['description LIKE ?', params[:account][:type_id]])
    if @type
      @type = @type.id
    end

    @parent = Account.find(:first, :conditions => ['number LIKE ?', params[:account][:parent_id][0..3]])
    if @parent
      @parent = @parent.id
    end
    
    @account = Account.new({
      :name => params[:account][:name],
      :fiscal_period_id => @fiscal_period,
      :number => params[:account][:number],
      :description => params[:account][:description],
      :type_id => @type,
      :parent_id => @parent
      })
    if @account.save
      flash[:notice] = 'Account was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @account = Account.find(params[:id])
    @fiscal_period_id = FiscalPeriod.find(@account[:fiscal_period_id]) unless @account[:fiscal_period_id].nil?
    @type_id = AccountType.find(@account[:type_id]) unless @account[:type_id].nil?
  end

  def update
    @account = Account.find(params[:id])
    @dates = params[:account][:fiscal_period_id].split(" - ")
    @fiscal_period = FiscalPeriod.find(:first,
      :conditions => ['startdate LIKE ? AND enddate LIKE ?', @dates[0], @dates[1] ])
    if @fiscal_period
      @fiscal_period = @fiscal_period.id
    end

    @type = AccountType.find(:first, :conditions => ['description LIKE ?', params[:account][:type_id]])
    if @type
      @type = @type.id
    end

    @parent = Account.find(:first, :conditions => ['number LIKE ?', params[:account][:parent_id][0..3]])
    if @parent
      @parent = @parent.id
    end
    
    if @account.update_attributes({
      :name => params[:account][:name],
      :fiscal_period_id => @fiscal_period,
      :number => params[:account][:number],
      :description => params[:account][:description],
      :type_id => @type,
      :parent_id => @parent
      })
    
      flash[:notice] = 'Account was successfully updated.'
      redirect_to :action => 'show', :id => @account
    else
      render :action => 'edit'
    end
  end

  def destroy
    Account.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def autocomplete_fiscal_period_id
      @fiscal_period_ids = FiscalPeriod.find(:all,
        :conditions => [ 'startdate LIKE ? OR enddate LIKE ?', '%'+params[:account][:fiscal_period_id]+'%', '%'+params[:account][:fiscal_period_id]+'%'] )
      @fiscal_period_id = params[:account][:fiscal_period_id]
      render :layout => false
  end
  
    def autocomplete_type_id
      @type_ids = AccountType.find(:all,
        :conditions => [ 'description LIKE ?', '%'+params[:account][:type_id]+'%'] )
      @type_id = params[:account][:type_id]
      render :layout => false
  end

    def autocomplete_parent_id
      @parent_ids = Account.find(:all,
        :conditions => [ 'number LIKE ? OR name LIKE ?', '%'+params[:account][:parent_id]+'%', '%'+params[:account][:parent_id]+'%'] )
      @parent_id = params[:account][:parent_id]
      render :layout => false
  end
end

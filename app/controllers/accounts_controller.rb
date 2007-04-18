class AccountsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    if !params[:query].nil?
      @fiscal_period_id = params[:query]
    elsif !session[:fiscal_period_id].nil?
      @fiscal_period_id = session[:fiscal_period_id]
    else
      @fiscal_period_id = FiscalPeriod.find(:first, :order => "startdate DESC", :select => "id").id
    end
    session[:fiscal_period_id] = @fiscal_period_id
    @headings = Account.find(:all, :conditions => ['parent_id IS NULL AND fiscal_period_id = ?', @fiscal_period_id])
    @headings.sort! {|a,b| a.smallest_child <=> b.smallest_child }
    @accounts = Hash.new
    for h in @headings
      @accounts[h.id] = Account.find(:all, :conditions => ['parent_id = ?', h.id])
    end

    if request.xml_http_request?
      render :partial => "list", :layout => false
    end

    @fp_options = FiscalPeriod.find(:all, :order => "id DESC").map {|fp| [[fp.startdate.strftime("%d.%m.%Y"), " - ", fp.enddate.strftime("%d.%m.%Y")], fp.id.to_s] }

  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
    @fiscal_period = FiscalPeriod.find(:first, :conditions => ['id = ?', params[:fiscal_period_id]])
  end

  def create
    @dates = params[:account][:fiscal_period_id].split(" - ")
    @dates[0] = Date.strptime(@dates[0], "%d.%m.%Y")
    @dates[1] = Date.strptime(@dates[1], "%d.%m.%Y")
    @fiscal_period_id = FiscalPeriod.find(:first,
      :conditions => ['startdate LIKE ? AND enddate LIKE ?', @dates[0], @dates[1] ])
    if @fiscal_period_id
      @fiscal_period_id = @fiscal_period_id.id
    end

    @type = AccountType.find(:first, :conditions => ['description LIKE ?', params[:account][:type_id]])
    if @type
      @type = @type.id
    end

    @parent = Account.find(:first, :conditions => ['name LIKE ?', params[:account][:parent_id][5..-1]])
    if @parent
      @parent = @parent.id
    end
    
    @account = Account.new({
      :name => params[:account][:name],
      :fiscal_period_id => @fiscal_period_id,
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
    @fiscal_period = FiscalPeriod.find(@account[:fiscal_period_id]) unless @account[:fiscal_period_id].nil?
    @type_id = AccountType.find(@account[:type_id]) unless @account[:type_id].nil?
    @parent_id = Account.find(@account[:parent_id]) unless @account[:parent_id].nil?
  end

  def update
    @account = Account.find(params[:id])
    @dates = params[:account][:fiscal_period_id].split(" - ")
    @dates[0] = Date.strptime(@dates[0], "%d.%m.%Y")
    @dates[1] = Date.strptime(@dates[1], "%d.%m.%Y")
    @fiscal_period_id = FiscalPeriod.find(:first,
      :conditions => ['startdate LIKE ? AND enddate LIKE ?', @dates[0], @dates[1] ])
    if @fiscal_period_id
      @fiscal_period_id = @fiscal_period_id.id
    end

    @type = AccountType.find(:first, :conditions => ['description LIKE ?', params[:account][:type_id]])
    if @type
      @type = @type.id
    end

    @parent = Account.find(:first, :conditions => ['name LIKE ?', params[:account][:parent_id][5..-1]])
    if @parent
      @parent = @parent.id
    end
    
    if @account.update_attributes({
      :name => params[:account][:name],
      :fiscal_period_id => @fiscal_period_id,
      :number => params[:account][:number],
      :description => params[:account][:description],
      :type_id => @type,
      :parent_id => @parent
      })
    
      flash[:notice] = 'Account ' +@account.send("name") +' was successfully updated.'
      redirect_to :action => 'list'
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

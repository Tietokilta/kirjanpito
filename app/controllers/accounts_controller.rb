class AccountsController < ApplicationController
  layout nil
  layout "application", :except => :pdftest

  def index
    list
		if ! request.xml_http_request?
	    render :action => 'list'
		end
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def pdftest
    @time = Time.now
  end

  def list
    if !params[:query].nil?
      @fiscal_period_id = params[:query]
    elsif !session[:fiscal_period_id].nil?
      @fiscal_period_id = session[:fiscal_period_id]
    else
      @fiscal_period_id = FiscalPeriod.find(:first, :order => "startdate DESC", :select => "id").id
    end
    session[:fiscal_period_id] = @fiscal_period_id
    @headings = Account.find(:all, :conditions => ['parent_id IS NULL AND type_id = 2 AND fiscal_period_id = ?', @fiscal_period_id])
    #@headings.sort! {|a,b| a.smallest_child <=> b.smallest_child }
    @headings.sort! {|a,b| a.id <=> b.id }

		sort = "number"
		sort = params['sort'] if params['sort']


		if params[:search]
			@tmp_accounts = Account.find(:all, :conditions => ["parent_id IS NOT NULL AND fiscal_period_id = ? AND type_id = 2  AND (number LIKE '%' ? '%' OR name LIKE '%' ? '%' OR description LIKE '%' ? '%')", @fiscal_period_id,  params[:search], params[:search], params[:search]], :order => sort, :include => :budget_accounts)

		else
			@tmp_accounts = Account.find(:all, :conditions => ['parent_id IS NOT NULL AND fiscal_period_id = ? AND type_id = 2 ', @fiscal_period_id], :order => sort, :include => :budget_accounts)
		end

    @accounts = Hash.new
		@tmp_accounts.each { |x| 
			@accounts[x.parent_id] = Array.new unless @accounts[x.parent_id]
			@accounts[x.parent_id].push x	
		}
		@headings.delete_if { |h| !@accounts[h.id] }
		
	
		@account_balance = Entry.getbalances @fiscal_period_id

    if request.xml_http_request?
      render :partial => "list", :layout => false
    end

     @fp_options = FiscalPeriod.find(:all, :order => "id DESC").map {|fp| [[fp.startdate.strftime("%d.%m.%Y"), " - ", fp.enddate.strftime("%d.%m.%Y")], fp.id.to_s] }

  end

  def show
    @account = Account.find(params[:id], :include => [:budget_accounts, :parent])
		@deb = Entry.find(:all, :conditions => ['debet_account_id = ?', @account.id], :order => 'date asc')
		@cred = Entry.find(:all, :conditions => ['credit_account_id = ?', @account.id], :order => 'date asc')

  end

  def new
    @account = Account.new
		@account.fiscal_period_id = session[:fiscal_period_id]
  end

  def create
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
      :fiscal_period_id => params[:account][:fiscal_period_id],
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
    @type_id = AccountType.find(@account[:type_id]) unless @account[:type_id].nil?
    @parent_id = Account.find(@account[:parent_id]) unless @account[:parent_id].nil?
  end

  def update
    @account = Account.find(params[:id])

    @type = AccountType.find(:first, :conditions => ['description LIKE ?', params[:account][:type_id]])
    if @type
      @type = @type.id
    end

    @parent = Account.find(:first, :conditions => ['name LIKE ?', params[:account][:parent_id][5..-1]])
    if @parent
      @parent = @parent.id
    end
    
    if @account.update_attributes({ :name => params[:account][:name],
                                    :fiscal_period_id => params[:account][:fiscal_period_id],
                                    :number => params[:account][:number],
                                    :description => params[:account][:description],
                                    :type_id => @type,
                                    :parent_id => @parent})
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

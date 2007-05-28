class AccountsController < ApplicationController
  layout nil
  layout "application", :except => [:ledger, :balance]
	
	before_filter :pages
	def pages
		@pages = {
			'list' => _("Account list"), 
			'ledger' => _("General ledger"), 
			'balance' => _("Income & balance sheet")
			}
	end


  def index
    list
		if ! request.xml_http_request?
	    redirect_to :action => 'list'
		end
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

	def ledger
		@options_for_rtex = Hash.new
		@options_for_rtex[:preprocess] = true
		@options_for_rtex[:filename] = 'generalledger.pdf'

		@accounts = Account.find(:all, :conditions => ['accounts.fiscal_period_id = ?', session[:fiscal_period_id]], :order => 'number')
		@fp = FiscalPeriod.find session[:fiscal_period_id] 
	end

	def balance
		list
		@options_for_rtex = Hash.new
		@options_for_rtex[:preprocess] = true
		@options_for_rtex[:filename] = 'balances.pdf'

		@fp = FiscalPeriod.find session[:fiscal_period_id] 

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

    @headings = Account.find(:all, :conditions => ['parent_id IS NULL AND fiscal_period_id = ?', @fiscal_period_id])
    #@headings.sort! {|a,b| a.smallest_child <=> b.smallest_child }
    @headings.sort! {|a,b| a.id <=> b.id }

		sort = "number"
		sort = params['sort'] if params['sort']
		sqlsort = "number"

		field = sort.scan(/\w+/)[0]
		case field
			when 'number':
				sqlsort = field
			when 'name':
				sqlsort = field
			when 'description':
				sqlsort = field
		end

		if sort.scan(/\w+/)[1] == 'desc' then
			sqlsort = sqlsort + " asc"
		end

		if params[:search]
			@tmp_accounts = Account.find(:all, :conditions => ["parent_id IS NOT NULL AND fiscal_period_id = ? AND (number LIKE '%' ? '%' OR name LIKE '%' ? '%' OR description LIKE '%' ? '%')", @fiscal_period_id,  params[:search], params[:search], params[:search]], :order => sqlsort, :include => :budget_accounts)

		else
			@tmp_accounts = Account.find(:all, :conditions => ['parent_id IS NOT NULL AND fiscal_period_id = ?', @fiscal_period_id], :order => sqlsort, :include => :budget_accounts)
		end
		
		@account_balance = Entry.getbalances session[:fiscal_period_id]

    @accounts = Hash.new
		@account_sums = Hash.new
		@tmp_accounts.each { |x| 
			@accounts[x.parent_id] = Array.new unless @accounts[x.parent_id]
			@accounts[x.parent_id].push x	

			@account_sums[x.parent_id] = { :balance => 0, :budget => 0 } unless @account_sums[x.parent_id]	
			@account_sums[x.parent_id][:balance] += @account_balance[x.id] if @account_balance[x.id]
			@account_sums[x.parent_id][:budget] += x.budget
			
		}
		@headings.delete_if { |h| !@accounts[h.id] }
		
	

		case sort.scan(/\w+/)[0]
			when 'balance':
				@accounts.each { |a|
					next unless @accounts[a[0]]
					@accounts[a[0]].each { |b|
						@account_balance[b.id] = 0 unless @account_balance[b.id]
					}
					
					@accounts[a[0]].sort! {|a,b| @account_balance[a.id] <=> @account_balance[b.id] }
				}
			# TODO: propably some optimization available.
			when 'budget':
				@accounts.each { |a|
					next unless @accounts[a[0]]
					
					@accounts[a[0]].sort! {|a,b|
						a.budget <=> b.budget
					}
				}
			when 'status':
				@accounts.each { |a|
					next unless @accounts[a[0]]
					@accounts[a[0]].each { |b|
						@account_balance[b.id] = 0 unless @account_balance[b.id]
					}
					
					@accounts[a[0]].sort! {|a,b|
						(a.budget-@account_balance[a.id]) <=> 
						(b.budget-@account_balance[b.id])

					}
				}
		end

		if sort.scan(/\w+/)[1] == 'desc'
			@accounts.each { |a|
				next unless @accounts[a[0]]
				
				@accounts[a[0]].reverse!
			}
		end
		
		
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

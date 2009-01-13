class AccountsController < ApplicationController
  layout nil
  layout "application", :except => [:ledger, :balance]
	
	before_filter :pages
	def pages
		@pages = {
			'list' => _("Account list"), 
			'history' => _("Account history"), 
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
		
		@startdate = Date.parse(params[:start]) if params[:start]
		@enddate = Date.parse(params[:end]) if params[:end]

		@startdate ||= @fp.startdate
		@enddate ||= @fp.enddate

	end

	def balance
		@fp = FiscalPeriod.find session[:fiscal_period_id] 
		@startdate = Date.parse(params[:start]) if params[:start]
		@enddate = Date.parse(params[:end]) if params[:end]

		@startdate ||= @fp.startdate
		@enddate ||= @fp.enddate
		
		list
		@options_for_rtex = Hash.new
		@options_for_rtex[:preprocess] = true
		@options_for_rtex[:filename] = 'balances.pdf'
	end

	def history

		sql = "
			SELECT s.fiscal_period_id, s.number, s.name, s.parent_id, sum(deb) as total, b.description as bdesc, ba.sum as budget FROM 
			(SELECT a.fiscal_period_id, a.id, a.number, a.name, a.parent_id, -sum(ed.sum) as deb
				FROM accounts a
				LEFT JOIN entries ed ON a.id = ed.debet_account_id
				GROUP BY a.id
				UNION
				SELECT a.fiscal_period_id, a.id, a.number, a.name, a.parent_id, sum(ec.sum) as cred
				FROM accounts a
				LEFT JOIN entries ec ON a.id = ec.credit_account_id
				GROUP BY a.id
			) as s
			INNER JOIN budget_accounts ba ON s.id = ba.account_id
			INNER JOIN budgets b ON ba.budget_id = b.id
			GROUP by s.id, ba.id
			ORDER by s.number, fiscal_period_id, ba.id"

		@tmp_accounts = Hash.new
		@allyears = SortedSet.new

		srch = params["search"]
		srch.downcase! if srch
		ActiveRecord::Base.connection.select_all(sql).each { |x|
			if srch then
				next unless x["number"].include?(srch) || x["name"].downcase.include?(srch)
			end
			num = x["number"].to_i
			yr = x["fiscal_period_id"]
			@tmp_accounts[num] = {:number => num, :name => x["name"]} unless @tmp_accounts[num]
			@tmp_accounts[num][yr + " " + _("actual")] = x["total"]
			@tmp_accounts[num][yr + " " + x["bdesc"]] = x["budget"]
			
			@allyears << yr + " " + _("actual")
			@allyears << yr + " " + x["bdesc"]
		}


		@accounts = Hash.new
		@account_sums = Hash.new
		@final_sum = Hash.new
		@allyears.each { |y|
			@final_sum[y] = 0
		}

		@tmp_accounts.each { |num,x|
			#parent = x["parent_id"].to_i.modulo 10000;
			parent = num / 100
			@accounts[parent] = Array.new unless @accounts[parent]
			@accounts[parent].push x	
			
			unless @account_sums[parent] then
				@account_sums[parent] = Hash.new
				@allyears.each { |y|
					@account_sums[parent][y] = 0
				}
			end
			x.each { |a,b|
				next if a == :number || a == :name
				@account_sums[parent][a] += b.to_f
				@final_sum[a] += b.to_f
			}
		}

		@accounts.each { |a|
			next unless @accounts[a[0]]
			
			@accounts[a[0]].sort! {|a,b|
				a[:number] <=> b[:number]
			}
		}


		if params['year'] then
			@years = Array.new
			params['year'].each { |y,v|
				next unless v=="1"
				@years.push y
			}
		else
			@years = @allyears
		end

		@years.sort! unless @years.is_a? Set
    
		@headings = Account.find(:all, :conditions => ['parent_id IS NULL AND type_id = 2'], :group => 'name')
    #@headings.sort! {|a,b| a.smallest_child <=> b.smallest_child }
    @headings.sort! {|a,b| a.number <=> b.number }

		@headings.reject! {|a| a.name == "Kulttuuritoiminta ja liikunta" }

    if request.xml_http_request?
      render :partial => "history", :layout => false
    end


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

		@last_balance_id = 1;

		@headings.each {|h| @last_balance_id = h.id if h.type_id==2 && @last_balance_id < h.id }


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
		
		@account_balance = Entry.getbalances session[:fiscal_period_id], @startdate, @enddate

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

    @parent = Account.find(:first, :conditions => ['name LIKE ? and fiscal_period_id = ?', params[:account][:parent_id][5..-1], session[:fiscal_period_id]])
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

    @parent = Account.find(:first, :conditions => ['name LIKE ? and fiscal_period_id = ?', params[:account][:parent_id][5..-1], session[:fiscal_period_id]])
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
        :conditions => [ '(number LIKE ? OR name LIKE ?) and fiscal_period_id = ?', '%'+params[:account][:parent_id]+'%', '%'+params[:account][:parent_id]+'%', session[:fiscal_period_id]] )
      @parent_id = params[:account][:parent_id]
      render :layout => false
  end
end

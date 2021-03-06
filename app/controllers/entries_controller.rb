class EntriesController < ApplicationController
  layout "application", :except => :ledger

  def index
    redirect_to(:action => 'list')
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
       
	def ledger
		@options_for_rtex = Hash.new
		@options_for_rtex[:preprocess] = true
		@options_for_rtex[:filename] = 'dailyledger.pdf'

		@startdate = Date.parse(params[:start]) if params[:start]
		@enddate = Date.parse(params[:end]) if params[:end]
		
		@fp = FiscalPeriod.find session[:fiscal_period_id] 

		@startdate ||= @fp.startdate
		@enddate ||= @fp.enddate

		@entries = Entry.find(:all, :conditions => ['entries.fiscal_period_id = ? AND entries.date BETWEEN ? AND ?', session[:fiscal_period_id], @startdate, @enddate], :order => 'date, receipt_number, entries.description', :include => ['credit_account', 'debet_account'])
	end

  def list
		conditions = ["entries.fiscal_period_id = ?", session[:fiscal_period_id]]
		conditions = ["entries.fiscal_period_id = ? AND (receipt_number LIKE '%' ? '%' OR entries.description  LIKE '%' ? '%' OR sum LIKE '%' ? '%' OR date LIKE '%' ? '%' OR debet_account_id LIKE '%' ? '%' OR credit_account_id LIKE '%' ? '%')", session[:fiscal_period_id], params[:search], params[:search], params[:search], params[:search], params[:search], params[:search]] if params[:search]

		order = "receipt_number desc"
		order = params[:sort] if params[:sort]
	  order = "entries.description" if order == "description"

    @entries = Entry.paginate :page => params[:page], :per_page => 100, :conditions => conditions, :order => order, :include => [:credit_account, :debet_account]
		
		# Call new entry for the instant entry
		new

		# If an AJAX call..
		
    if request.xml_http_request?
			case params[:action]
				when 'add_to_entries'
				when 'destroy'
				else
					render :partial => "list", :layout => false
			end
    end
	end

  def add_to_entries
		params[:entry][:sum].tr! ",", "."

    @entry = Entry.new(params[:entry])
		@saved = @entry.save

		list
		redirect_to(:action => 'list') unless request.xml_http_request?
	end

  def show
    @entry = Entry.find(params[:id])
  end

  def new
		@latestEntry = Entry.find(:first, :order => "receipt_number desc, id desc", :conditions => ['fiscal_period_id = ?', session[:fiscal_period_id]])
		@entry = Entry.new
		
		unless @latestEntry.nil?
			@entry.receipt_number = @latestEntry.receipt_number + 1
			@entry.fiscal_period_id = session[:fiscal_period_id]
			@entry.date = @latestEntry.date
			@entry.sum = @latestEntry.sum
			@entry.description = @latestEntry.description
			@entry.debet_account = @latestEntry.debet_account
			@entry.credit_account = @latestEntry.credit_account
		else
			@entry.receipt_number = 1
		end
  end

	# Should not be used
  def create
		params[:entry][:sum].tr! ",", "."

    @entry = Entry.new(params[:entry])

    if @entry.save
      flash[:notice] = 'Entry was successfully created.'
      #redirect_to :action => 'list'
      redirect_to :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
		params[:entry][:sum].tr! ",", "."

    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      flash[:notice] = 'Entry was successfully updated.'
      redirect_to :action => 'show', :id => @entry
    else
      render :action => 'edit'
    end
  end

	# TODO: New entry does not update on destroy action.
  def destroy
    Entry.find(params[:id]).destroy
#     redirect_to :action => 'list'
    list
  end

	def autocomplete_debet_account
		data = params[:debet_account]
		@accounts = Account.find(:all,
				:conditions => [ '(number LIKE ? OR name LIKE ?) AND fiscal_period_id = ? ', '%'+data+'%', '%'+data+'%', session[:fiscal_period_id]] )
		render :inline => "<%= indexed_auto_complete_result @accounts, 'entry_debet_account_id', 'name', 'id' %>" 
	end

	def autocomplete_credit_account
		data = params[:credit_account]
		@accounts = Account.find(:all,
				:conditions => [ '(number LIKE ? OR name LIKE ?) AND fiscal_period_id = ?', '%'+data+'%', '%'+data+'%', session[:fiscal_period_id]] )
		render :inline => "<%= indexed_auto_complete_result @accounts, 'entry_credit_account_id', 'name', 'id' %>" 
	end

end

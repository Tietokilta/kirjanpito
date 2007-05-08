class EntriesController < ApplicationController
  def index
    list
		if request.xml_http_request?
			render :partial => "list", :layout => false
		else
	    render :action => 'list'
		end

  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
		conditions = nil
		conditions = ["receipt_number LIKE '%' ? '%' OR entries.description  LIKE '%' ? '%' OR sum LIKE '%' ? '%' OR date LIKE '%' ? '%' OR debet_account_id LIKE '%' ? '%' OR credit_account_id LIKE '%' ? '%'", params[:search], params[:search], params[:search], params[:search], params[:search], params[:search]] if params[:search]

		order = "receipt_number"
		order = params[:sort] if params[:sort]

    @entry_pages, @entries = paginate :entries, :per_page => 100, :conditions => conditions, :order => order, :include => [:credit_account, :debet_account]
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def new
		@entry = Entry.find(:first, :order => "receipt_number desc, id desc", :conditions => ['fiscal_period_id = ?', session[:fiscal_period_id]])
		@entry.id += 1
		@entry.receipt_number += 1
		@entry.fiscal_period_id = session[:fiscal_period_id]
  end

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

  def destroy
    Entry.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

	def autocomplete_debet_account
		data = params[:debet_account]
		@accounts = Account.find(:all,
				:conditions => [ 'number LIKE ? OR name LIKE ?', '%'+data+'%', '%'+data+'%'] )
		render :inline => "<%= indexed_auto_complete_result @accounts, 'entry_debet_account_id', 'name', 'id' %>" 
	end

	def autocomplete_credit_account
		data = params[:credit_account]
		@accounts = Account.find(:all,
				:conditions => [ 'number LIKE ? OR name LIKE ?', '%'+data+'%', '%'+data+'%'] )
		render :inline => "<%= indexed_auto_complete_result @accounts, 'entry_credit_account_id', 'name', 'id' %>" 
	end

end

class EntriesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @entry_pages, @entries = paginate :entries, :per_page => 10
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def new
		#TODO: fetch fiscal period from somewhere
		@entry = Entry.find(:first, :order => "id desc", :conditions => ['fiscal_period_id = ?', 2006])
		@entry.id += 1
		@entry.receipt_number += 1
  end

  def create
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

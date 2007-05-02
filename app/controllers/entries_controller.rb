class EntriesController < ApplicationController

  active_scaffold :entry do |config|
    config.columns = [:receipt_number, :description, :sum, :date, :fiscal_period.to_s, :debet_account, :credit_account]
#    config.columns[:phone_number].description = "(Format: ###-###-####)"
#    config.columns[:phone_number].label = "Phone"

    config.create.columns.exclude :receipt_number
    config.update.columns.exclude :receipt_number
#    config.list.columns.exclude :first_name, :middle_name, :last_name
#    config.subform.columns = [:first_name, :last_name, :login, :password]

    config.list.sorting = {:date => 'ASC'}

#    config.nested.add_link "Names", [:aliases]

#    config.create.columns.exclude(:first_name, :middle_name, :last_name, :phone_number)
#    config.create.columns.add_subgroup "Optional" do |group|
#      group.add(:first_name, :middle_name, :last_name, :phone_number)
#    end
  end

#  def index
#    list
#    render :action => 'list'
#  end
#
#  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }
#
#  def list
#    @entry_pages, @entries = paginate :entries, :per_page => 10
#  end
#
#  def show
#    @entry = Entry.find(params[:id])
#  end
#
#  def new
#		#TODO: fetch fiscal period from somewhere
#		@entry = Entry.find(:first, :order => "id desc", :conditions => ['fiscal_period_id = ?', 2006])
#		@entry.id += 1
#		@entry.receipt_number += 1
#  end
#
#  def create
#    @entry = Entry.new(params[:entry])
#
#    if @entry.save
#      flash[:notice] = 'Entry was successfully created.'
#      #redirect_to :action => 'list'
#      redirect_to :action => 'new'
#    else
#      render :action => 'new'
#    end
#  end
#
#  def edit
#    @entry = Entry.find(params[:id])
#  end
#
#  def update
#    @entry = Entry.find(params[:id])
#    if @entry.update_attributes(params[:entry])
#      flash[:notice] = 'Entry was successfully updated.'
#      redirect_to :action => 'show', :id => @entry
#    else
#      render :action => 'edit'
#    end
#  end
#
#  def destroy
#    Entry.find(params[:id]).destroy
#    redirect_to :action => 'list'
#  end
#
#	def autocomplete_debet_account
#		data = params[:debet_account]
#		@accounts = Account.find(:all,
#				:conditions => [ 'number LIKE ? OR name LIKE ?', '%'+data+'%', '%'+data+'%'] )
#		render :inline => "<%= indexed_auto_complete_result @accounts, 'entry_debet_account_id', 'name', 'id' %>" 
#	end
#
#	def autocomplete_credit_account
#		data = params[:credit_account]
#		@accounts = Account.find(:all,
#				:conditions => [ 'number LIKE ? OR name LIKE ?', '%'+data+'%', '%'+data+'%'] )
#		render :inline => "<%= indexed_auto_complete_result @accounts, 'entry_credit_account_id', 'name', 'id' %>" 
#	end

end

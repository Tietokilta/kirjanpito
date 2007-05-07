class InvoicesController < ApplicationController
# TODO: csv export, import??
# TODO: ilmo integration
# TODO: group by description and seperate different with &lt;hr&gt;
# TODO: whole thing with these :) [when invoice is paid, transfer to entry]
# TODO: siirtosaamiset (vuoden lopun säätö..), siirtovelat
	active_scaffold :invoice do |config|
		config.create.columns = [:description, :payer, :payer_contact, :sum, :date, :paymentdate, :fiscal_period]
		config.list.columns   = [:description, :payer, :payer_contact, :sum, :date, :paymentdate, :fiscal_period]
	end

#   def index
#     list
#     render :action => 'list'
#   end
# 
#   # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#   verify :method => :post, :only => [ :destroy, :create, :update ],
#          :redirect_to => { :action => :list }
# 
#   def list
#     @invoice_pages, @invoices = paginate :invoices, :per_page => 10
#   end
# 
#   def show
#     @invoice = Invoice.find(params[:id])
#   end
# 
#   def new
#     @invoice = Invoice.new
#   end
# 
  def create
    @invoice = Invoice.new(params[:invoice])
		@invoice.target_account_id = 1
		@invoice.source_account_id = 1
    if @invoice.save
      flash[:notice] = 'Invoice was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
# 
#   def edit
#     @invoice = Invoice.find(params[:id])
#   end
# 
#   def update
#     @invoice = Invoice.find(params[:id])
#     if @invoice.update_attributes(params[:invoice])
#       flash[:notice] = 'Invoice was successfully updated.'
#       redirect_to :action => 'show', :id => @invoice
#     else
#       render :action => 'edit'
#     end
#   end
# 
#   def destroy
#     Invoice.find(params[:id]).destroy
#     redirect_to :action => 'list'
#   end
end

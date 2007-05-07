class FiscalPeriodsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @fiscal_period_pages, @fiscal_periods = paginate :fiscal_periods, :per_page => 10, :order => "startdate"
  end

  def show
    @fiscal_period = FiscalPeriod.find(params[:id])
  end

  def new
    @fiscal_period = FiscalPeriod.new
  end

  def create
    @fiscal_period = FiscalPeriod.new(params[:fiscal_period])
    if @fiscal_period.save
      flash[:notice] = 'FiscalPeriod was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @fiscal_period = FiscalPeriod.find(params[:id])
  end

  def update
    @fiscal_period = FiscalPeriod.find(params[:id])
    if @fiscal_period.update_attributes(params[:fiscal_period])
      flash[:notice] = 'FiscalPeriod was successfully updated.'
      redirect_to :action => 'show', :id => @fiscal_period
    else
      render :action => 'edit'
    end
  end

  def destroy
    FiscalPeriod.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

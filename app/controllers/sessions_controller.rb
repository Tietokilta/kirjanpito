# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  #before_filter :login_from_cookie

  skip_before_filter :login_required
  after_filter :new

  # render new.rhtml
  def new
    session[:return_to] = nil
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
			set_my_fiscal_period
      redirect_back_or_default('/accounts')
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
	
	private
		def set_my_fiscal_period
			unless session[:fiscal_period_id].nil?
				@fiscal_period_id = session[:fiscal_period_id]
			else
				@fiscal_period_id = FiscalPeriod.find(:first, :order => "startdate DESC", :select => "id").id
			end
			session[:fiscal_period_id] = @fiscal_period_id
		end
end

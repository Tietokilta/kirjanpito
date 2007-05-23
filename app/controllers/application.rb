# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_TiKirjanpito_session_id'

  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :login_required
  after_filter :store_location

	before_filter :check_fiscal_period_change

  protected
    def authorized?
      if(request.path_parameters[:action] == "edit" ||
         request.path_parameters[:action] == "new" ||
         request.path_parameters[:action] == "create" ||
         request.path_parameters[:action] == "destroy")
        if @current_user != nil
          return @current_user.level >= 2
        end
        return false
      end
      
      true
    end

    def access_denied
      if session[:return_to].nil?
        flash[:notice] = "You are not logged in!"
      else
        flash[:notice] = "You are not authorized to do that!"
      end

      redirect_back_or_default('')
    end

		def check_fiscal_period_change
			session[:fiscal_period_id] = params[:new_fiscal_period] if params[:new_fiscal_period]
		end

end

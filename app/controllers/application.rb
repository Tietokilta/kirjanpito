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
      flash[:notice] = "You are not authorized to do that!"
      redirect_back_or_default('/accounts')
    end
end

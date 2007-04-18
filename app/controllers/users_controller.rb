class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  #before_filter :login_from_cookie

  def index
    list
    render :action => 'list'
  end

  def list
    @user_pages, @users = paginate :users, :per_page => 20, :order => :login
  end

  # render new.rhtml
  def new
  end

  def create
    @user = User.new(params[:user])
    @user.save!
    #self.current_user = @user
    redirect_back_or_default('/users')
    flash[:notice] = "User added!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  protected
    # Check if the user is authorized.
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the user
    # has the correct rights.
    def authorize?
      current_user.level >= 2
    end
end

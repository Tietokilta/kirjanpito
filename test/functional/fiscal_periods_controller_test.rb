require File.dirname(__FILE__) + '/../test_helper'
require 'fiscal_periods_controller'

# Re-raise errors caught by the controller.
class FiscalPeriodsController; def rescue_action(e) raise e end; end

class FiscalPeriodsControllerTest < Test::Unit::TestCase
  fixtures :fiscal_periods

  def setup
    @controller = FiscalPeriodsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = fiscal_periods(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:fiscal_periods)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:fiscal_period)
    assert assigns(:fiscal_period).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:fiscal_period)
  end

  def test_create
    num_fiscal_periods = FiscalPeriod.count

    post :create, :fiscal_period => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_fiscal_periods + 1, FiscalPeriod.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:fiscal_period)
    assert assigns(:fiscal_period).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      FiscalPeriod.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      FiscalPeriod.find(@first_id)
    }
  end
end

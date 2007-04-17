require File.dirname(__FILE__) + '/../test_helper'
require 'budget_accounts_controller'

# Re-raise errors caught by the controller.
class BudgetAccountsController; def rescue_action(e) raise e end; end

class BudgetAccountsControllerTest < Test::Unit::TestCase
  fixtures :budget_accounts

  def setup
    @controller = BudgetAccountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = budget_accounts(:first).id
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

    assert_not_nil assigns(:budget_accounts)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:budget_account)
    assert assigns(:budget_account).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:budget_account)
  end

  def test_create
    num_budget_accounts = BudgetAccount.count

    post :create, :budget_account => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_budget_accounts + 1, BudgetAccount.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:budget_account)
    assert assigns(:budget_account).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      BudgetAccount.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      BudgetAccount.find(@first_id)
    }
  end
end

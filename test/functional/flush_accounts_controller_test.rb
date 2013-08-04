require 'test_helper'

class FlushAccountsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flush_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flush_account" do
    assert_difference('FlushAccount.count') do
      post :create, :flush_account => { }
    end

    assert_redirected_to flush_account_path(assigns(:flush_account))
  end

  test "should show flush_account" do
    get :show, :id => flush_accounts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => flush_accounts(:one).to_param
    assert_response :success
  end

  test "should update flush_account" do
    put :update, :id => flush_accounts(:one).to_param, :flush_account => { }
    assert_redirected_to flush_account_path(assigns(:flush_account))
  end

  test "should destroy flush_account" do
    assert_difference('FlushAccount.count', -1) do
      delete :destroy, :id => flush_accounts(:one).to_param
    end

    assert_redirected_to flush_accounts_path
  end
end

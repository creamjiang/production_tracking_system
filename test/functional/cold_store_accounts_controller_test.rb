require 'test_helper'

class ColdStoreAccountsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cold_store_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cold_store_account" do
    assert_difference('ColdStoreAccount.count') do
      post :create, :cold_store_account => { }
    end

    assert_redirected_to cold_store_account_path(assigns(:cold_store_account))
  end

  test "should show cold_store_account" do
    get :show, :id => cold_store_accounts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => cold_store_accounts(:one).to_param
    assert_response :success
  end

  test "should update cold_store_account" do
    put :update, :id => cold_store_accounts(:one).to_param, :cold_store_account => { }
    assert_redirected_to cold_store_account_path(assigns(:cold_store_account))
  end

  test "should destroy cold_store_account" do
    assert_difference('ColdStoreAccount.count', -1) do
      delete :destroy, :id => cold_store_accounts(:one).to_param
    end

    assert_redirected_to cold_store_accounts_path
  end
end

require 'test_helper'

class AccountStatementsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:account_statements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account_statement" do
    assert_difference('AccountStatement.count') do
      post :create, :account_statement => { }
    end

    assert_redirected_to account_statement_path(assigns(:account_statement))
  end

  test "should show account_statement" do
    get :show, :id => account_statements(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => account_statements(:one).to_param
    assert_response :success
  end

  test "should update account_statement" do
    put :update, :id => account_statements(:one).to_param, :account_statement => { }
    assert_redirected_to account_statement_path(assigns(:account_statement))
  end

  test "should destroy account_statement" do
    assert_difference('AccountStatement.count', -1) do
      delete :destroy, :id => account_statements(:one).to_param
    end

    assert_redirected_to account_statements_path
  end
end

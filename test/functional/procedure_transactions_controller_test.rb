require 'test_helper'

class ProcedureTransactionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:procedure_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create procedure_transaction" do
    assert_difference('ProcedureTransaction.count') do
      post :create, :procedure_transaction => { }
    end

    assert_redirected_to procedure_transaction_path(assigns(:procedure_transaction))
  end

  test "should show procedure_transaction" do
    get :show, :id => procedure_transactions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => procedure_transactions(:one).to_param
    assert_response :success
  end

  test "should update procedure_transaction" do
    put :update, :id => procedure_transactions(:one).to_param, :procedure_transaction => { }
    assert_redirected_to procedure_transaction_path(assigns(:procedure_transaction))
  end

  test "should destroy procedure_transaction" do
    assert_difference('ProcedureTransaction.count', -1) do
      delete :destroy, :id => procedure_transactions(:one).to_param
    end

    assert_redirected_to procedure_transactions_path
  end
end

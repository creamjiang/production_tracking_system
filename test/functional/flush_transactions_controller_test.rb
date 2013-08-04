require 'test_helper'

class FlushTransactionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flush_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flush_transaction" do
    assert_difference('FlushTransaction.count') do
      post :create, :flush_transaction => { }
    end

    assert_redirected_to flush_transaction_path(assigns(:flush_transaction))
  end

  test "should show flush_transaction" do
    get :show, :id => flush_transactions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => flush_transactions(:one).to_param
    assert_response :success
  end

  test "should update flush_transaction" do
    put :update, :id => flush_transactions(:one).to_param, :flush_transaction => { }
    assert_redirected_to flush_transaction_path(assigns(:flush_transaction))
  end

  test "should destroy flush_transaction" do
    assert_difference('FlushTransaction.count', -1) do
      delete :destroy, :id => flush_transactions(:one).to_param
    end

    assert_redirected_to flush_transactions_path
  end
end

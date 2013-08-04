require 'test_helper'

class PrmsBalancesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prms_balances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prms_balance" do
    assert_difference('PrmsBalance.count') do
      post :create, :prms_balance => { }
    end

    assert_redirected_to prms_balance_path(assigns(:prms_balance))
  end

  test "should show prms_balance" do
    get :show, :id => prms_balances(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prms_balances(:one).to_param
    assert_response :success
  end

  test "should update prms_balance" do
    put :update, :id => prms_balances(:one).to_param, :prms_balance => { }
    assert_redirected_to prms_balance_path(assigns(:prms_balance))
  end

  test "should destroy prms_balance" do
    assert_difference('PrmsBalance.count', -1) do
      delete :destroy, :id => prms_balances(:one).to_param
    end

    assert_redirected_to prms_balances_path
  end
end

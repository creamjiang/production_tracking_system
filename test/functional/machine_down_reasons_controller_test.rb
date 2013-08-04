require 'test_helper'

class MachineDownReasonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:machine_down_reasons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create machine_down_reason" do
    assert_difference('MachineDownReason.count') do
      post :create, :machine_down_reason => { }
    end

    assert_redirected_to machine_down_reason_path(assigns(:machine_down_reason))
  end

  test "should show machine_down_reason" do
    get :show, :id => machine_down_reasons(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => machine_down_reasons(:one).to_param
    assert_response :success
  end

  test "should update machine_down_reason" do
    put :update, :id => machine_down_reasons(:one).to_param, :machine_down_reason => { }
    assert_redirected_to machine_down_reason_path(assigns(:machine_down_reason))
  end

  test "should destroy machine_down_reason" do
    assert_difference('MachineDownReason.count', -1) do
      delete :destroy, :id => machine_down_reasons(:one).to_param
    end

    assert_redirected_to machine_down_reasons_path
  end
end

require 'test_helper'

class MachineDowntimesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:machine_downtimes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create machine_downtime" do
    assert_difference('MachineDowntime.count') do
      post :create, :machine_downtime => { }
    end

    assert_redirected_to machine_downtime_path(assigns(:machine_downtime))
  end

  test "should show machine_downtime" do
    get :show, :id => machine_downtimes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => machine_downtimes(:one).to_param
    assert_response :success
  end

  test "should update machine_downtime" do
    put :update, :id => machine_downtimes(:one).to_param, :machine_downtime => { }
    assert_redirected_to machine_downtime_path(assigns(:machine_downtime))
  end

  test "should destroy machine_downtime" do
    assert_difference('MachineDowntime.count', -1) do
      delete :destroy, :id => machine_downtimes(:one).to_param
    end

    assert_redirected_to machine_downtimes_path
  end
end

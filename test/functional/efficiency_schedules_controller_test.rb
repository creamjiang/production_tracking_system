require 'test_helper'

class EfficiencySchedulesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:efficiency_schedules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create efficiency_schedule" do
    assert_difference('EfficiencySchedule.count') do
      post :create, :efficiency_schedule => { }
    end

    assert_redirected_to efficiency_schedule_path(assigns(:efficiency_schedule))
  end

  test "should show efficiency_schedule" do
    get :show, :id => efficiency_schedules(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => efficiency_schedules(:one).to_param
    assert_response :success
  end

  test "should update efficiency_schedule" do
    put :update, :id => efficiency_schedules(:one).to_param, :efficiency_schedule => { }
    assert_redirected_to efficiency_schedule_path(assigns(:efficiency_schedule))
  end

  test "should destroy efficiency_schedule" do
    assert_difference('EfficiencySchedule.count', -1) do
      delete :destroy, :id => efficiency_schedules(:one).to_param
    end

    assert_redirected_to efficiency_schedules_path
  end
end

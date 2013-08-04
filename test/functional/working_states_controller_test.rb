require 'test_helper'

class WorkingStatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:working_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create working_state" do
    assert_difference('WorkingState.count') do
      post :create, :working_state => { }
    end

    assert_redirected_to working_state_path(assigns(:working_state))
  end

  test "should show working_state" do
    get :show, :id => working_states(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => working_states(:one).to_param
    assert_response :success
  end

  test "should update working_state" do
    put :update, :id => working_states(:one).to_param, :working_state => { }
    assert_redirected_to working_state_path(assigns(:working_state))
  end

  test "should destroy working_state" do
    assert_difference('WorkingState.count', -1) do
      delete :destroy, :id => working_states(:one).to_param
    end

    assert_redirected_to working_states_path
  end
end

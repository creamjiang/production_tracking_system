require 'test_helper'

class RoutingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:routings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create routing" do
    assert_difference('Routing.count') do
      post :create, :routing => { }
    end

    assert_redirected_to routing_path(assigns(:routing))
  end

  test "should show routing" do
    get :show, :id => routings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => routings(:one).to_param
    assert_response :success
  end

  test "should update routing" do
    put :update, :id => routings(:one).to_param, :routing => { }
    assert_redirected_to routing_path(assigns(:routing))
  end

  test "should destroy routing" do
    assert_difference('Routing.count', -1) do
      delete :destroy, :id => routings(:one).to_param
    end

    assert_redirected_to routings_path
  end
end

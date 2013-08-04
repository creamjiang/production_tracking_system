require 'test_helper'

class PrmsLocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prms_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prms_location" do
    assert_difference('PrmsLocation.count') do
      post :create, :prms_location => { }
    end

    assert_redirected_to prms_location_path(assigns(:prms_location))
  end

  test "should show prms_location" do
    get :show, :id => prms_locations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prms_locations(:one).to_param
    assert_response :success
  end

  test "should update prms_location" do
    put :update, :id => prms_locations(:one).to_param, :prms_location => { }
    assert_redirected_to prms_location_path(assigns(:prms_location))
  end

  test "should destroy prms_location" do
    assert_difference('PrmsLocation.count', -1) do
      delete :destroy, :id => prms_locations(:one).to_param
    end

    assert_redirected_to prms_locations_path
  end
end

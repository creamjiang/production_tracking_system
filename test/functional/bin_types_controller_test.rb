require 'test_helper'

class BinTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bin_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bin_type" do
    assert_difference('BinType.count') do
      post :create, :bin_type => { }
    end

    assert_redirected_to bin_type_path(assigns(:bin_type))
  end

  test "should show bin_type" do
    get :show, :id => bin_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bin_types(:one).to_param
    assert_response :success
  end

  test "should update bin_type" do
    put :update, :id => bin_types(:one).to_param, :bin_type => { }
    assert_redirected_to bin_type_path(assigns(:bin_type))
  end

  test "should destroy bin_type" do
    assert_difference('BinType.count', -1) do
      delete :destroy, :id => bin_types(:one).to_param
    end

    assert_redirected_to bin_types_path
  end
end

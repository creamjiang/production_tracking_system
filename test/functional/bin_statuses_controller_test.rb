require 'test_helper'

class BinStatusesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bin_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bin_status" do
    assert_difference('BinStatus.count') do
      post :create, :bin_status => { }
    end

    assert_redirected_to bin_status_path(assigns(:bin_status))
  end

  test "should show bin_status" do
    get :show, :id => bin_statuses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bin_statuses(:one).to_param
    assert_response :success
  end

  test "should update bin_status" do
    put :update, :id => bin_statuses(:one).to_param, :bin_status => { }
    assert_redirected_to bin_status_path(assigns(:bin_status))
  end

  test "should destroy bin_status" do
    assert_difference('BinStatus.count', -1) do
      delete :destroy, :id => bin_statuses(:one).to_param
    end

    assert_redirected_to bin_statuses_path
  end
end

require 'test_helper'

class SwapGroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:swap_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create swap_group" do
    assert_difference('SwapGroup.count') do
      post :create, :swap_group => { }
    end

    assert_redirected_to swap_group_path(assigns(:swap_group))
  end

  test "should show swap_group" do
    get :show, :id => swap_groups(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => swap_groups(:one).to_param
    assert_response :success
  end

  test "should update swap_group" do
    put :update, :id => swap_groups(:one).to_param, :swap_group => { }
    assert_redirected_to swap_group_path(assigns(:swap_group))
  end

  test "should destroy swap_group" do
    assert_difference('SwapGroup.count', -1) do
      delete :destroy, :id => swap_groups(:one).to_param
    end

    assert_redirected_to swap_groups_path
  end
end

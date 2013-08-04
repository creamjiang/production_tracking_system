require 'test_helper'

class BinsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bin" do
    assert_difference('Bin.count') do
      post :create, :bin => { }
    end

    assert_redirected_to bin_path(assigns(:bin))
  end

  test "should show bin" do
    get :show, :id => bins(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bins(:one).to_param
    assert_response :success
  end

  test "should update bin" do
    put :update, :id => bins(:one).to_param, :bin => { }
    assert_redirected_to bin_path(assigns(:bin))
  end

  test "should destroy bin" do
    assert_difference('Bin.count', -1) do
      delete :destroy, :id => bins(:one).to_param
    end

    assert_redirected_to bins_path
  end
end

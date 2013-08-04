require 'test_helper'

class RejectCodesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reject_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reject_code" do
    assert_difference('RejectCode.count') do
      post :create, :reject_code => { }
    end

    assert_redirected_to reject_code_path(assigns(:reject_code))
  end

  test "should show reject_code" do
    get :show, :id => reject_codes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => reject_codes(:one).to_param
    assert_response :success
  end

  test "should update reject_code" do
    put :update, :id => reject_codes(:one).to_param, :reject_code => { }
    assert_redirected_to reject_code_path(assigns(:reject_code))
  end

  test "should destroy reject_code" do
    assert_difference('RejectCode.count', -1) do
      delete :destroy, :id => reject_codes(:one).to_param
    end

    assert_redirected_to reject_codes_path
  end
end

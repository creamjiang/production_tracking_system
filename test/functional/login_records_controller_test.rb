require 'test_helper'

class LoginRecordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:login_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create login_record" do
    assert_difference('LoginRecord.count') do
      post :create, :login_record => { }
    end

    assert_redirected_to login_record_path(assigns(:login_record))
  end

  test "should show login_record" do
    get :show, :id => login_records(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => login_records(:one).to_param
    assert_response :success
  end

  test "should update login_record" do
    put :update, :id => login_records(:one).to_param, :login_record => { }
    assert_redirected_to login_record_path(assigns(:login_record))
  end

  test "should destroy login_record" do
    assert_difference('LoginRecord.count', -1) do
      delete :destroy, :id => login_records(:one).to_param
    end

    assert_redirected_to login_records_path
  end
end

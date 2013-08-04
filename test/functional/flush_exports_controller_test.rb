require 'test_helper'

class FlushExportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flush_exports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flush_export" do
    assert_difference('FlushExport.count') do
      post :create, :flush_export => { }
    end

    assert_redirected_to flush_export_path(assigns(:flush_export))
  end

  test "should show flush_export" do
    get :show, :id => flush_exports(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => flush_exports(:one).to_param
    assert_response :success
  end

  test "should update flush_export" do
    put :update, :id => flush_exports(:one).to_param, :flush_export => { }
    assert_redirected_to flush_export_path(assigns(:flush_export))
  end

  test "should destroy flush_export" do
    assert_difference('FlushExport.count', -1) do
      delete :destroy, :id => flush_exports(:one).to_param
    end

    assert_redirected_to flush_exports_path
  end
end

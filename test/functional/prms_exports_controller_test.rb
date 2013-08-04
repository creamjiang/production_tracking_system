require 'test_helper'

class PrmsExportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prms_exports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prms_export" do
    assert_difference('PrmsExport.count') do
      post :create, :prms_export => { }
    end

    assert_redirected_to prms_export_path(assigns(:prms_export))
  end

  test "should show prms_export" do
    get :show, :id => prms_exports(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prms_exports(:one).to_param
    assert_response :success
  end

  test "should update prms_export" do
    put :update, :id => prms_exports(:one).to_param, :prms_export => { }
    assert_redirected_to prms_export_path(assigns(:prms_export))
  end

  test "should destroy prms_export" do
    assert_difference('PrmsExport.count', -1) do
      delete :destroy, :id => prms_exports(:one).to_param
    end

    assert_redirected_to prms_exports_path
  end
end

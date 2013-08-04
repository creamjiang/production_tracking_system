require 'test_helper'

class FlushProceduresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flush_procedures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flush_procedure" do
    assert_difference('FlushProcedure.count') do
      post :create, :flush_procedure => { }
    end

    assert_redirected_to flush_procedure_path(assigns(:flush_procedure))
  end

  test "should show flush_procedure" do
    get :show, :id => flush_procedures(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => flush_procedures(:one).to_param
    assert_response :success
  end

  test "should update flush_procedure" do
    put :update, :id => flush_procedures(:one).to_param, :flush_procedure => { }
    assert_redirected_to flush_procedure_path(assigns(:flush_procedure))
  end

  test "should destroy flush_procedure" do
    assert_difference('FlushProcedure.count', -1) do
      delete :destroy, :id => flush_procedures(:one).to_param
    end

    assert_redirected_to flush_procedures_path
  end
end

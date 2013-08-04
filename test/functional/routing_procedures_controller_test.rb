require 'test_helper'

class RoutingProceduresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:routing_procedures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create routing_procedure" do
    assert_difference('RoutingProcedure.count') do
      post :create, :routing_procedure => { }
    end

    assert_redirected_to routing_procedure_path(assigns(:routing_procedure))
  end

  test "should show routing_procedure" do
    get :show, :id => routing_procedures(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => routing_procedures(:one).to_param
    assert_response :success
  end

  test "should update routing_procedure" do
    put :update, :id => routing_procedures(:one).to_param, :routing_procedure => { }
    assert_redirected_to routing_procedure_path(assigns(:routing_procedure))
  end

  test "should destroy routing_procedure" do
    assert_difference('RoutingProcedure.count', -1) do
      delete :destroy, :id => routing_procedures(:one).to_param
    end

    assert_redirected_to routing_procedures_path
  end
end

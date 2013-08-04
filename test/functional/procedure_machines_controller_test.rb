require 'test_helper'

class ProcedureMachinesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:procedure_machines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create procedure_machine" do
    assert_difference('ProcedureMachine.count') do
      post :create, :procedure_machine => { }
    end

    assert_redirected_to procedure_machine_path(assigns(:procedure_machine))
  end

  test "should show procedure_machine" do
    get :show, :id => procedure_machines(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => procedure_machines(:one).to_param
    assert_response :success
  end

  test "should update procedure_machine" do
    put :update, :id => procedure_machines(:one).to_param, :procedure_machine => { }
    assert_redirected_to procedure_machine_path(assigns(:procedure_machine))
  end

  test "should destroy procedure_machine" do
    assert_difference('ProcedureMachine.count', -1) do
      delete :destroy, :id => procedure_machines(:one).to_param
    end

    assert_redirected_to procedure_machines_path
  end
end

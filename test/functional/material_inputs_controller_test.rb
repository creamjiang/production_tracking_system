require 'test_helper'

class MaterialInputsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:material_inputs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create material_input" do
    assert_difference('MaterialInput.count') do
      post :create, :material_input => { }
    end

    assert_redirected_to material_input_path(assigns(:material_input))
  end

  test "should show material_input" do
    get :show, :id => material_inputs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => material_inputs(:one).to_param
    assert_response :success
  end

  test "should update material_input" do
    put :update, :id => material_inputs(:one).to_param, :material_input => { }
    assert_redirected_to material_input_path(assigns(:material_input))
  end

  test "should destroy material_input" do
    assert_difference('MaterialInput.count', -1) do
      delete :destroy, :id => material_inputs(:one).to_param
    end

    assert_redirected_to material_inputs_path
  end
end

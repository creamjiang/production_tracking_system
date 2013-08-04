require 'test_helper'

class ShiftsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Shift.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Shift.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Shift.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to shift_url(assigns(:shift))
  end
  
  def test_edit
    get :edit, :id => Shift.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Shift.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Shift.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Shift.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Shift.first
    assert_redirected_to shift_url(assigns(:shift))
  end
  
  def test_destroy
    shift = Shift.first
    delete :destroy, :id => shift
    assert_redirected_to shifts_url
    assert !Shift.exists?(shift.id)
  end
end

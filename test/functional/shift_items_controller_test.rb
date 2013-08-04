require 'test_helper'

class ShiftItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => ShiftItem.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    ShiftItem.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    ShiftItem.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to shift_item_url(assigns(:shift_item))
  end
  
  def test_edit
    get :edit, :id => ShiftItem.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    ShiftItem.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ShiftItem.first
    assert_template 'edit'
  end
  
  def test_update_valid
    ShiftItem.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ShiftItem.first
    assert_redirected_to shift_item_url(assigns(:shift_item))
  end
  
  def test_destroy
    shift_item = ShiftItem.first
    delete :destroy, :id => shift_item
    assert_redirected_to shift_items_url
    assert !ShiftItem.exists?(shift_item.id)
  end
end

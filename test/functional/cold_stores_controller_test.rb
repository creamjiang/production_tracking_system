require 'test_helper'

class ColdStoresControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => ColdStore.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    ColdStore.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    ColdStore.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to cold_store_url(assigns(:cold_store))
  end
  
  def test_edit
    get :edit, :id => ColdStore.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    ColdStore.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ColdStore.first
    assert_template 'edit'
  end
  
  def test_update_valid
    ColdStore.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ColdStore.first
    assert_redirected_to cold_store_url(assigns(:cold_store))
  end
  
  def test_destroy
    cold_store = ColdStore.first
    delete :destroy, :id => cold_store
    assert_redirected_to cold_stores_url
    assert !ColdStore.exists?(cold_store.id)
  end
end

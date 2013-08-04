require 'test_helper'

class ProcedureProductsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => ProcedureProduct.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    ProcedureProduct.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    ProcedureProduct.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to procedure_product_url(assigns(:procedure_product))
  end
  
  def test_edit
    get :edit, :id => ProcedureProduct.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    ProcedureProduct.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ProcedureProduct.first
    assert_template 'edit'
  end
  
  def test_update_valid
    ProcedureProduct.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ProcedureProduct.first
    assert_redirected_to procedure_product_url(assigns(:procedure_product))
  end
  
  def test_destroy
    procedure_product = ProcedureProduct.first
    delete :destroy, :id => procedure_product
    assert_redirected_to procedure_products_url
    assert !ProcedureProduct.exists?(procedure_product.id)
  end
end

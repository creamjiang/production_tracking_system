require 'test_helper'

class TransactionSummariesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => TransactionSummary.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    TransactionSummary.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    TransactionSummary.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to transaction_summary_url(assigns(:transaction_summary))
  end
  
  def test_edit
    get :edit, :id => TransactionSummary.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    TransactionSummary.any_instance.stubs(:valid?).returns(false)
    put :update, :id => TransactionSummary.first
    assert_template 'edit'
  end
  
  def test_update_valid
    TransactionSummary.any_instance.stubs(:valid?).returns(true)
    put :update, :id => TransactionSummary.first
    assert_redirected_to transaction_summary_url(assigns(:transaction_summary))
  end
  
  def test_destroy
    transaction_summary = TransactionSummary.first
    delete :destroy, :id => transaction_summary
    assert_redirected_to transaction_summaries_url
    assert !TransactionSummary.exists?(transaction_summary.id)
  end
end

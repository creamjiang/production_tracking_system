require 'test_helper'

class BinClearingRecordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bin_clearing_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bin_clearing_record" do
    assert_difference('BinClearingRecord.count') do
      post :create, :bin_clearing_record => { }
    end

    assert_redirected_to bin_clearing_record_path(assigns(:bin_clearing_record))
  end

  test "should show bin_clearing_record" do
    get :show, :id => bin_clearing_records(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bin_clearing_records(:one).to_param
    assert_response :success
  end

  test "should update bin_clearing_record" do
    put :update, :id => bin_clearing_records(:one).to_param, :bin_clearing_record => { }
    assert_redirected_to bin_clearing_record_path(assigns(:bin_clearing_record))
  end

  test "should destroy bin_clearing_record" do
    assert_difference('BinClearingRecord.count', -1) do
      delete :destroy, :id => bin_clearing_records(:one).to_param
    end

    assert_redirected_to bin_clearing_records_path
  end
end

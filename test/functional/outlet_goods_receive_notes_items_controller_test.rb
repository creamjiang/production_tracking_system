require 'test_helper'

class OutletGoodsReceiveNotesItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:outlet_goods_receive_notes_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create outlet_goods_receive_notes_item" do
    assert_difference('OutletGoodsReceiveNotesItem.count') do
      post :create, :outlet_goods_receive_notes_item => { }
    end

    assert_redirected_to outlet_goods_receive_notes_item_path(assigns(:outlet_goods_receive_notes_item))
  end

  test "should show outlet_goods_receive_notes_item" do
    get :show, :id => outlet_goods_receive_notes_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => outlet_goods_receive_notes_items(:one).to_param
    assert_response :success
  end

  test "should update outlet_goods_receive_notes_item" do
    put :update, :id => outlet_goods_receive_notes_items(:one).to_param, :outlet_goods_receive_notes_item => { }
    assert_redirected_to outlet_goods_receive_notes_item_path(assigns(:outlet_goods_receive_notes_item))
  end

  test "should destroy outlet_goods_receive_notes_item" do
    assert_difference('OutletGoodsReceiveNotesItem.count', -1) do
      delete :destroy, :id => outlet_goods_receive_notes_items(:one).to_param
    end

    assert_redirected_to outlet_goods_receive_notes_items_path
  end
end

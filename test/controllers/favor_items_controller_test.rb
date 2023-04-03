require "test_helper"

class FavorItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @favor_item = favor_items(:one)
  end

  test "should get index" do
    get favor_items_url
    assert_response :success
  end

  test "should get new" do
    get new_favor_item_url
    assert_response :success
  end

  test "should create favor_item" do
    assert_difference("FavorItem.count") do
      post favor_items_url, params: { product_id: products(:one).id }
    end
  end

  test "should show favor_item" do
    get favor_item_url(@favor_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_favor_item_url(@favor_item)
    assert_response :success
  end

  test "should update favor_item" do
    patch favor_item_url(@favor_item), params: { favor_item: { product_id: @favor_item.product_id, user_id: @favor_item.user_id } }
    assert_redirected_to favor_item_url(@favor_item)
  end

  test "should destroy favor_item" do
    assert_difference("FavorItem.count", -1) do
      delete favor_item_url(@favor_item)
    end

    assert_redirected_to favor_items_url
  end
end

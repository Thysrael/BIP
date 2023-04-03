require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    # 这个 product 用于测试 create 和 update 功能
    @update = {
      title: 'Lorem Ipsum',
      description: 'Wobbles are fun!',
      image_url: 'compiler.jpg',
      price: 19.95
    }
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    # 这里说的是发送一个 params 为 @update 的 post，用于测试创建
    assert_difference("Product.count") do
      post products_url, params: { product: @update }
    end
    # 应当重定位到最后一个 product
    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: @update }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      # delete 也是 request 的一种，会被翻译成 post
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end

  test "can't delete product in cart" do
    assert_difference('Product.count', 0) do
      delete product_url(products(:two))
    end
  end
end

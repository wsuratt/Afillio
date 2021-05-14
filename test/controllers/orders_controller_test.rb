require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post orders_url, params: { order: { city: @order.city, email: @order.email, first_name: @order.first_name, last_name: @order.last_name, phone: @order.phone, product_id: @order.product_id, quantity: @order.quantity, state: @order.state, street_address: @order.street_address, total: @order.total, user_id: @order.user_id, zipcode: @order.zipcode } }
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { city: @order.city, email: @order.email, first_name: @order.first_name, last_name: @order.last_name, phone: @order.phone, product_id: @order.product_id, quantity: @order.quantity, state: @order.state, street_address: @order.street_address, total: @order.total, user_id: @order.user_id, zipcode: @order.zipcode } }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end

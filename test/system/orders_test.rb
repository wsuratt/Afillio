require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "creating a Order" do
    visit orders_url
    click_on "New Order"

    fill_in "City", with: @order.city
    fill_in "Email", with: @order.email
    fill_in "First name", with: @order.first_name
    fill_in "Last name", with: @order.last_name
    fill_in "Phone", with: @order.phone
    fill_in "Product", with: @order.product_id
    fill_in "Quantity", with: @order.quantity
    fill_in "State", with: @order.state
    fill_in "Street address", with: @order.street_address
    fill_in "Total", with: @order.total
    fill_in "User", with: @order.user_id
    fill_in "Zipcode", with: @order.zipcode
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "updating a Order" do
    visit orders_url
    click_on "Edit", match: :first

    fill_in "City", with: @order.city
    fill_in "Email", with: @order.email
    fill_in "First name", with: @order.first_name
    fill_in "Last name", with: @order.last_name
    fill_in "Phone", with: @order.phone
    fill_in "Product", with: @order.product_id
    fill_in "Quantity", with: @order.quantity
    fill_in "State", with: @order.state
    fill_in "Street address", with: @order.street_address
    fill_in "Total", with: @order.total
    fill_in "User", with: @order.user_id
    fill_in "Zipcode", with: @order.zipcode
    click_on "Update Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "destroying a Order" do
    visit orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed"
  end
end

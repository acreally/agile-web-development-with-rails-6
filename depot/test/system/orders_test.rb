require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "creating a Order using check as a payment method" do
    # first, add an item to a cart because
    # we cannot create an order with an empty cart
    visit store_index_url
    click_on "Add to Cart", match: :first
    click_on "Checkout"

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name

    assert_selector "#order_pay_type"
    assert_selector "option[value=\"Check\"]"
    assert_no_selector "#order_routing_number"

    select "Check", from: "Pay type"

    assert_selector "#order_routing_number"
    assert_selector "#order_account_number"
    fill_in "Routing #", with: "123"
    fill_in "Account #", with: "12345678"

    click_on "Place Order"

    assert_text "Thank you for your order."
  end

  test "updating a Order" do
    visit orders_url
    click_on "Edit", match: :first

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
    fill_in "Pay type", with: @order.payment_type
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

require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "creating a Order using check as a payment method" do
    arrange_create_order("Check")

    assert_no_selector "#order_routing_number"
    assert_no_selector "#order_account_number"
    select "Check", from: "Pay with"
    assert_selector "#order_routing_number"
    assert_selector "#order_account_number"
    fill_in "Routing #", with: "123"
    fill_in "Account #", with: "12345678"

    assert_create_order("Check")
  end

  test "creating a Order using credit card as a payment method" do
    arrange_create_order("Credit card")

    assert_no_selector "#order_credit_card_number"
    assert_no_selector "#order_expiration_date"
    select "Credit Card", from: "Pay with"
    assert_selector "#order_credit_card_number"
    assert_selector "#order_expiration_date"
    fill_in "CC #", with: "4111111111111111"
    fill_in "Expiry", with: "01/25"

    assert_create_order("Credit card")
  end

  test "creating a Order using purchase order as a payment method" do
    arrange_create_order("Purchase order")

    assert_no_selector "#order_po_number"
    select "Purchase Order", from: "Pay with"
    assert_selector "#order_po_number"
    fill_in "PO #", with: "12345678"

    assert_create_order("Purchase order")
  end

  test "updating a Order" do
    visit orders_url
    click_on "Edit", match: :first

    fill_in "Address", with: @order.address
    fill_in "E-mail", with: @order.email
    fill_in "Name", with: @order.name
    select "Check", from: "Pay with"
    fill_in "Routing #", with: "123"
    fill_in "Account #", with: "12345678"

    click_on "Place Order"

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

  private

  def arrange_create_order(payment_method)
    LineItem.delete_all
    Order.delete_all

    # add an item to a cart because
    # we cannot create an order with an empty cart
    visit store_index_url
    click_on "Add to Cart", match: :first
    click_on "Checkout"

    fill_in "Address", with: @order.address
    fill_in "E-mail", with: @order.email
    fill_in "Name", with: @order.name

    assert_selector "#order_pay_type"
    assert_selector "option[value=\"#{payment_method}\"]"
  end

  def assert_create_order(expected_payment_method)
    perform_enqueued_jobs do
      click_on "Place Order"
    end

    assert_text "Thank you for your order"

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal @order.name, order.name
    assert_equal @order.address, order.address
    assert_equal @order.email, order.email
    assert_equal expected_payment_method, order.payment_type.payment_method
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal [@order.email], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject

  end
end

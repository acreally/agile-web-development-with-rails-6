require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  setup do
    @order = orders(:one)
  end

  test "received" do
    expected_body = /Dear #{@order.name}[[:space:]]+Thank you for your recent order from The Pragmatic Store.[[:space:]]+You ordered the following items:[[:space:]]+1 . MyString2[[:space:]]+We'll send you a separate email when your order ships./
    mail = OrderMailer.received(@order)
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal [@order.email], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match expected_body, mail.body.encoded
  end

  test "shipped" do
    expected_body = /Dear #{@order.name}[[:space:]]+Your order has been shipped.[[:space:]]+It will be delivered to:[[:space:]]+#{@order.address}/
    mail = OrderMailer.shipped(@order)
    assert_equal "Pramatic Store Order Shipped", mail.subject
    assert_equal [@order.email], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match expected_body, mail.body.encoded
  end
end

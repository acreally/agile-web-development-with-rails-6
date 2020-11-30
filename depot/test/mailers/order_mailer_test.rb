require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  setup do
    @order = orders(:one)
  end

  test "received" do
    expected_body = /Dear #{@order.name}\s+Thank you for your recent order from The Pragmatic Store.\s+You ordered the following items:\s+1 . MyString2\s+We'll send you a separate email when your order ships./
    mail = OrderMailer.received(@order)
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal [@order.email], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match expected_body, mail.body.encoded
  end

  test "shipped" do
    expected_body = /<h3>Pragmatic Order Shipped<\/h3>\s+<p>\s+This is just to let you know that we've shipped your recent order:\s+<\/p>\s+<table>\s+<tr><th colspan="2">Qty<\/th><th>Description<\/th><\/tr>\s+<td[^>]*>1<\/td>\s+<td>MyString2<\/td>\s+<td[^>]*>\$9.99<\/td>\s+<\/table>/
    mail = OrderMailer.shipped(@order)
    assert_equal "Pramatic Store Order Shipped", mail.subject
    assert_equal [@order.email], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match expected_body, mail.body.encoded
  end
end

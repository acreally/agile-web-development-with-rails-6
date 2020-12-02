require 'test_helper'
require './lib/pago'
require 'ostruct'

class ChargeOrderJobTest < ActiveJob::TestCase
  def setup
    @payment_result = OpenStruct.new(succeeded?: true)
    @mock_mailer = mock()
  end

  test "payment with a check sends details to payment processor and emails customer" do
    order = orders(:one)
    pay_type_params = {
      routing_number: "123",
      account_number: "12345678",
    }

    expected_payment_details = {
      routing: "123",
      account: "12345678",
    }

    assert_perform(expected_payment_details, :check, order, pay_type_params)
  end

  test "payment with a credit card sends details to payment processor and emails customer" do
    order = orders(:two)
    pay_type_params = {
      credit_card_number: "4123123412341234",
      expiration_date: "01/25",
    }

    expected_payment_details = {
      cc_num: "4123123412341234",
      expiration_month: "01",
      expiration_year: "25",
    }

    assert_perform(expected_payment_details, :credit_card, order, pay_type_params)
  end

  test "payment with a purchase order sends details to payment processor and emails customer" do
    order = orders(:three)
    pay_type_params = {
      po_number: "12345678",
    }

    expected_payment_details = {
      po_num: "12345678",
    }

    assert_perform(expected_payment_details, :po, order, pay_type_params)
  end

  private

  def assert_perform(expected_payment_details, expected_payment_method, order, pay_type_params)
    Pago.expects(:make_payment).with(
      order_id: order.id,
      payment_method: expected_payment_method,
      payment_details: expected_payment_details).returns(@payment_result)
    OrderMailer.expects(:received).with(order).returns(@mock_mailer)
    @mock_mailer.expects(:deliver_later)

    ChargeOrderJob.perform_now(order, pay_type_params)
  end
end

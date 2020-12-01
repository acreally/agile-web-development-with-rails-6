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

    Pago.expects(:make_payment).with(order_id: order.id, payment_method: :check, payment_details: expected_payment_details).returns(@payment_result)
    OrderMailer.expects(:received).with(order).returns(@mock_mailer)
    @mock_mailer.expects(:deliver_later)

    ChargeOrderJob.perform_now(order, pay_type_params)
  end
end

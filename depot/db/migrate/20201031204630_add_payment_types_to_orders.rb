class AddPaymentTypesToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :payment_type, foreign_key: true
  end
end

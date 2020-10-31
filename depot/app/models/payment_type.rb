class PaymentType < ApplicationRecord
  validates :payment_method, uniqueness: true
end

class PaymentType < ApplicationRecord
  has_many :orders
  validates :payment_method, uniqueness: true
end

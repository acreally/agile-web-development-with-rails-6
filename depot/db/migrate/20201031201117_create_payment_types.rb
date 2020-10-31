class CreatePaymentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_types do |t|
      t.string :payment_method

      t.timestamps
    end
    add_index :payment_types, :payment_method, unique: true
  end
end

class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string  :transaction_number, null: false
      t.integer :customer_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.string  :status, null: false

      t.timestamps
    end

    add_index :transactions, :transaction_number, unique: true
    add_foreign_key :transactions, :customers
    add_foreign_key :transactions, :products
  end
end

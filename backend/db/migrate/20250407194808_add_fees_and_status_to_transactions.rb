class AddFeesAndStatusToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :base_fee, :decimal, precision: 10, scale: 2, default: 0, null: false
    add_column :transactions, :delivery_fee, :decimal, precision: 10, scale: 2, default: 0, null: false
    add_column :transactions, :provider_transaction_id, :string
    add_column :transactions, :failure_reason, :string
  end
end

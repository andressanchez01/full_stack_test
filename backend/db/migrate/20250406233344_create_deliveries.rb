class CreateDeliveries < ActiveRecord::Migration[8.0]
  def change
    create_table :deliveries do |t|
      t.references :transaction, null: false, foreign_key: true
      t.string :address, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end

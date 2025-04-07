class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :name, null: false, limit: 100
      t.string :email, null: false
      t.string :phone, null: false, limit: 20
      t.string :address, null: false

      t.timestamps
    end

    add_index :customers, :email, unique: true
  end
end

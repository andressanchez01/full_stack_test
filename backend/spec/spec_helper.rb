require 'active_record'
require 'rspec'
require 'database_cleaner-active_record'


ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :customers, force: true do |t|
    t.string :name
    t.string :email
    t.string :phone
    t.string :address
    t.timestamps
  end

  create_table :transactions, force: true do |t|
    t.string :transaction_number
    t.integer :quantity
    t.decimal :base_fee, precision: 10, scale: 2
    t.decimal :delivery_fee, precision: 10, scale: 2
    t.decimal :total_amount, precision: 10, scale: 2
    t.string :status
    t.string :payment_id
    t.references :customer, foreign_key: true
    t.references :product, foreign_key: true
    t.timestamps
  end

  create_table :deliveries, force: true do |t|
    t.string :address
    t.string :city
    t.string :postal_code
    t.string :status
    t.references :transaction, foreign_key: true
    t.timestamps
  end

  create_table :products, force: true do |t|
    t.string :name
    t.decimal :price, precision: 10, scale: 2
    t.integer :stock_quantity
    t.timestamps
  end

end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.order = :random
  Kernel.srand config.seed
end
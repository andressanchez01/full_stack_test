
require 'dotenv/load'
require_relative './app/services/payment_service'
require_relative './app/services/result'

class Customer
  attr_accessor :email, :name
  def initialize(email, name)
    @email = email
    @name = name
  end
end

class Transaction
  attr_accessor :transaction_number, :total_amount, :customer
  def initialize(transaction_number, total_amount, customer)
    @transaction_number = transaction_number
    @total_amount = total_amount 
    @customer = customer
  end
end


customer = Customer.new("example@test.co", "Test User")
transaction = Transaction.new("TXN_001", 300000, customer)


card_data = {
  number: "4242424242424242",
  cvc: "123",
  exp_month: "12",
  exp_year: "30",
  card_holder: "Test User"
}


result = PaymentService.process_payment(transaction, card_data)

if result.success?
  puts "✅ Payment approved: #{result.value}"
else
  puts "❌ Payment failed: #{result.error}"
end

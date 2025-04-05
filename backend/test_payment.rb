require 'dotenv/load'
require_relative './app/services/payment_service'
require_relative './app/services/payment_status_service'
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
transaction = Transaction.new("TXN_007", 300000, customer)

card_data = {
  number: "4242424242424242",
  cvc: "123",
  exp_month: "12",
  exp_year: "30",
  card_holder: "Test User"
}

result = PaymentService.process_payment(transaction, card_data)

if result.success?
  transaction_id = result.value["id"]
  puts "✅ Pago iniciado con éxito. ID de transacción: #{transaction_id}"

  final_status = PaymentStatusService.poll_transaction_status(transaction_id)

  if final_status == "APPROVED"
    puts "✅ Pago aprobado."
  else
    puts "❌ El pago no fue aprobado. Estado final: #{final_status}"
  end
else
  puts "❌ Error al iniciar el pago: #{result.error}"
end
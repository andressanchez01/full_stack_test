require 'dotenv/load'
require_relative './app/services/payment_service'
require_relative './app/services/payment_status_service'

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

# Datos de prueba
customer = Customer.new("example@test.co", "Test User")
transaction = Transaction.new("TXN_007", 300000, customer)

card_data = {
  cardNumber: "4242424242424242",
  cvv: "123",
  expiryMonth: "12",
  expiryYear: "30",
  cardHolder: "Test User"
}

begin
  # Procesar el pago
  puts "🪵 [TEST_PAYMENT] Iniciando el pago..."
  payment_data = PaymentService.process_payment(transaction, card_data)
  puts "✅ [TEST_PAYMENT] Pago iniciado con éxito. ID de transacción: #{payment_data['id']}"

  # Consultar el estado final del pago
  final_status = PaymentStatusService.poll_transaction_status(payment_data['id'])

  if final_status == "APPROVED"
    puts "✅ [TEST_PAYMENT] Pago aprobado."
  else
    puts "❌ [TEST_PAYMENT] El pago no fue aprobado. Estado final: #{final_status}"
  end
rescue StandardError => e
  puts "❌ [TEST_PAYMENT] Error al procesar el pago: #{e.message}"
end
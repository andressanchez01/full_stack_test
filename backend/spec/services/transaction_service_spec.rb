require 'spec_helper'
require_relative '../../app/services/transaction_service' 
require_relative '../../app/repositories/product_repository'
require_relative '../../app/repositories/customer_repository'
require_relative '../../app/repositories/transaction_repository'
require_relative '../../app/services/payment_service'
require_relative '../../app/models/delivery'
require_relative '../../app/models/transaction'
require_relative '../../app/models/customer'
require_relative '../../app/models/product'


RSpec.describe TransactionService, type: :service do
  let(:product) { double('Product', id: 1, name: 'Product A', price: 100.0) }
  let(:customer) { double('Customer', id: 1, email: 'customer@example.com') }
  let(:transaction) { double('Transaction', id: 1, product_id: product.id, quantity: 2) }
  let(:delivery_params) { { address: '123 Main St', city: 'New York', postalCode: '10001' } }
  let(:card_data) { { cardNumber: '4111111111111111', cardHolder: 'John Doe', expiryMonth: '12', expiryYear: '2030', cvv: '123' } }

  before do
    allow(TransactionRepository).to receive(:find_by_id).and_return(transaction)
    allow(ProductRepository).to receive(:find_by_id).and_return(product)
    allow(CustomerRepository).to receive(:create_or_find).and_return(customer)
    allow(TransactionRepository).to receive(:create).and_return(transaction)
    allow(TransactionRepository).to receive(:update_status)
    allow(ProductRepository).to receive(:update_stock)
    allow(PaymentService).to receive(:process_payment).and_return({ 'id' => 'PAY-1234', 'status' => 'APPROVED' })
    allow(Delivery).to receive(:new).and_return(double(save: true, id: 1))
  end

  describe '.create_transaction' do
    it 'creates a transaction successfully' do
      params = {
        product_id: product.id,
        customer: { email: 'customer@example.com', name: 'John Doe', phone: '123456789', address: '123 Main St' },
        quantity: 2,
        delivery: delivery_params
      }

      allow(TransactionService::LOGGER).to receive(:info)

      result = TransactionService.create_transaction(params)

      expect(result).to eq(transaction)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Params recibidos/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Producto encontrado/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Cliente encontrado\/creado/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Monto total calculado/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Transacción creada/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Entrega creada para la transacción/)
    end

    it 'raises an error if the product is not found' do
      allow(ProductRepository).to receive(:find_by_id).and_return(nil)

      expect {
        TransactionService.create_transaction(product_id: 999, customer: {}, quantity: 1, delivery: {})
      }.to raise_error(StandardError, /Producto no encontrado/)
    end
  end

  describe '.process_payment' do
    it 'processes the payment successfully' do
      allow(TransactionService::LOGGER).to receive(:info)

      result = TransactionService.process_payment(transaction.id, card_data)

      expect(result).to eq(transaction)
      expect(TransactionService::LOGGER).to have_received(:info).with(/ID de transacción/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Pago procesado/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Estado de la transacción actualizado a COMPLETED/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Stock del producto actualizado/)
    end

    it 'raises an error if the payment fails' do
      allow(PaymentService).to receive(:process_payment).and_raise(StandardError, 'Payment failed')

      expect {
        TransactionService.process_payment(transaction.id, card_data)
      }.to raise_error(StandardError, /Payment failed/)
    end
  end

  describe '.mark_transaction_failed' do
    it 'marks the transaction as failed successfully' do
      reason = 'Insufficient funds'
      allow(TransactionService::LOGGER).to receive(:info)

      TransactionService.mark_transaction_failed(transaction.id, reason)

      expect(TransactionService::LOGGER).to have_received(:info).with(/ID de transacción/)
      expect(TransactionService::LOGGER).to have_received(:info).with(/Transacción marcada como fallida/)
    end

    it 'raises an error if marking the transaction as failed fails' do
      allow(TransactionRepository).to receive(:update_status).and_raise(StandardError, 'Database error')

      expect {
        TransactionService.mark_transaction_failed(transaction.id, 'Some reason')
      }.to raise_error(StandardError, /Database error/)
    end
  end
end
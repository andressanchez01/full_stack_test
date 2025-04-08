require 'spec_helper'
require_relative '../../app/controllers/transaction_controller'
require_relative '../../app/services/transaction_service'
require_relative '../../app/models/transaction'

RSpec.describe TransactionController, type: :controller do
  let(:transaction) do
    double(
      'Transaction',
      id: 1,
      total_amount: 150.0,
      status: 'PENDING',
      product_id: 1,
      customer_id: 1,
      delivery: double('Delivery', address: '123 Main St', city: 'New York'),
      created_at: Time.now,
      updated_at: Time.now
    )
  end

  describe '.create' do
    let(:params) do
      {
        product_id: 1,
        customer: { email: 'customer@example.com', name: 'John Doe', phone: '123456789', address: '123 Main St' },
        quantity: 2,
        delivery: { address: '123 Main St', city: 'New York', postalCode: '10001' }
      }
    end

    it 'creates a transaction successfully' do
      allow(TransactionService).to receive(:create_transaction).and_return(transaction)
      allow(TransactionController::LOGGER).to receive(:info)

      result = TransactionController.create(params)

      expect(result[:status]).to eq('success')
      expect(result[:data]).to eq(transaction)
      expect(TransactionController::LOGGER).to have_received(:info).with(/Recibiendo parámetros para crear transacción/)
      expect(TransactionController::LOGGER).to have_received(:info).with(/Transacción creada con éxito/)
    end

    it 'handles errors during transaction creation' do
      allow(TransactionService).to receive(:create_transaction).and_raise(StandardError, 'Creation failed')
      allow(TransactionController::LOGGER).to receive(:error)

      result = TransactionController.create(params)

      expect(result[:status]).to eq('error')
      expect(result[:message]).to eq('No se pudo crear la transacción')
      expect(result[:error]).to eq('Creation failed')
      expect(TransactionController::LOGGER).to have_received(:error).with(/Error al crear la transacción/)
    end
  end

  describe '.update' do
    let(:params) { { status: 'COMPLETED', card_data: { cardNumber: '4111111111111111' } } }

    it 'processes a payment successfully' do
      allow(TransactionService).to receive(:process_payment).and_return(transaction)
      allow(TransactionController::LOGGER).to receive(:info)

      result = TransactionController.update(1, params)

      expect(result[:status]).to eq('success')
      expect(result[:data]).to eq(transaction)
      expect(TransactionController::LOGGER).to have_received(:info).with(/Recibiendo parámetros para actualizar transacción/)
      expect(TransactionController::LOGGER).to have_received(:info).with(/Transacción actualizada con éxito/)
    end

    it 'marks a transaction as failed' do
      params = { status: 'FAILED', reason: 'Insufficient funds' }
      allow(TransactionService).to receive(:mark_transaction_failed).and_return(transaction)
      allow(TransactionController::LOGGER).to receive(:info)
    
      result = TransactionController.update(1, params)
    
      expect(result[:status]).to eq('success')
      expect(result[:data]).to eq(transaction)
      expect(TransactionController::LOGGER).to have_received(:info).with("[UPDATE] Recibiendo parámetros para actualizar transacción ID=1: #{params.inspect}")
      expect(TransactionController::LOGGER).to have_received(:info).with("[UPDATE] Transacción marcada como fallida: ID #{transaction.id}")
    end

    it 'returns an error for invalid status' do
      params = { status: 'INVALID' }
      allow(TransactionController::LOGGER).to receive(:warn)

      result = TransactionController.update(1, params)

      expect(result[:status]).to eq('error')
      expect(result[:message]).to eq('Invalid transaction status')
      expect(TransactionController::LOGGER).to have_received(:warn).with(/Estado de transacción inválido/)
    end

    it 'handles errors during update' do
      allow(TransactionService).to receive(:process_payment).and_raise(StandardError, 'Update failed')
      allow(TransactionController::LOGGER).to receive(:error)

      result = TransactionController.update(1, { status: 'COMPLETED', card_data: { cardNumber: '4111111111111111' } })

      expect(result[:status]).to eq('error')
      expect(result[:message]).to eq('No se pudo actualizar la transacción')
      expect(result[:error]).to eq('Update failed')
      expect(TransactionController::LOGGER).to have_received(:error).with(/Error al actualizar la transacción/)
    end
  end

  describe '.get_by_id' do
    it 'retrieves a transaction successfully' do
      allow(Transaction).to receive(:find_by).with(id: 1).and_return(transaction)
      allow(TransactionController::LOGGER).to receive(:info)

      result = TransactionController.get_by_id(1)

      expect(result[:status]).to eq('success')
      expect(result[:data][:id]).to eq(transaction.id)
      expect(result[:data][:delivery][:address]).to eq(transaction.delivery.address)
      expect(TransactionController::LOGGER).to have_received(:info).with(/Consultando transacción con ID/)
      expect(TransactionController::LOGGER).to have_received(:info).with(/Transacción encontrada/)
    end

    it 'returns an error if the transaction is not found' do
      allow(Transaction).to receive(:find_by).with(id: 1).and_return(nil)
      allow(TransactionController::LOGGER).to receive(:info)

      result = TransactionController.get_by_id(1)

      expect(result[:status]).to eq('error')
      expect(result[:message]).to eq('Transacción no encontrada')
      expect(TransactionController::LOGGER).to have_received(:info).with(/Consultando transacción con ID/)
      expect(TransactionController::LOGGER).to have_received(:info).with(/Transacción no encontrada/)
    end
  end
end
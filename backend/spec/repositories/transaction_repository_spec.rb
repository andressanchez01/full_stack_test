require 'spec_helper'
require_relative '../../app/repositories/transaction_repository'
require_relative '../../app/models/transaction'

RSpec.describe TransactionRepository, type: :repository do
  let(:logger) { Logger.new(STDOUT) }

  describe '.find_by_id' do
    context 'when the transaction exists' do
      it 'returns the transaction and logs the event' do
        transaction = Transaction.create!(transaction_number: 'TXN-1234', quantity: 2, base_fee: 10.0, delivery_fee: 5.0, total_amount: 15.0, status: 'PENDING')
        allow(TransactionRepository::LOGGER).to receive(:info) 

        found_transaction = TransactionRepository.find_by_id(transaction.id)

        expect(found_transaction).to eq(transaction)
        expect(TransactionRepository::LOGGER).to have_received(:info).with("[FIND_BY_ID] Transacción encontrada: ID=#{transaction.id}, Estado=#{transaction.status}")
      end
    end

    context 'when the transaction does not exist' do
      it 'raises an error and logs the event' do
        allow(TransactionRepository::LOGGER).to receive(:error) 

        expect {
          TransactionRepository.find_by_id(999)
        }.to raise_error(StandardError, 'Transacción con ID 999 no encontrada')

        expect(TransactionRepository::LOGGER).to have_received(:error).with("[FIND_BY_ID] Error al buscar la transacción: Transacción con ID 999 no encontrada")
      end
    end
  end

  describe '.create' do
    context 'when the transaction is valid' do
      it 'creates the transaction and logs the event' do
        allow(TransactionRepository::LOGGER).to receive(:info) 

        transaction = TransactionRepository.create(
          transaction_number: 'TXN-5678',
          quantity: 3,
          base_fee: 20.0,
          delivery_fee: 10.0,
          total_amount: 30.0,
          status: 'PENDING'
        )

        expect(transaction).to be_persisted
        expect(transaction.transaction_number).to eq('TXN-5678')
        expect(TransactionRepository::LOGGER).to have_received(:info).with("[CREATE] Transacción creada: ID=#{transaction.id}, Estado=#{transaction.status}")
      end
    end

    context 'when the transaction is invalid' do
      it 'raises an error and logs the event' do
        allow(TransactionRepository::LOGGER).to receive(:error) 

        expect {
          TransactionRepository.create(
            transaction_number: nil,
            quantity: 0,
            base_fee: -10.0,
            delivery_fee: 5.0,
            total_amount: 0.0,
            status: 'PENDING'
          )
        }.to raise_error(StandardError)

        expect(TransactionRepository::LOGGER).to have_received(:error).with(/Error al crear la transacción:/)
      end
    end
  end

  describe '.update_status' do
    context 'when the transaction exists' do
      it 'updates the status and logs the event' do
        transaction = Transaction.create!(transaction_number: 'TXN-1234', quantity: 2, base_fee: 10.0, delivery_fee: 5.0, total_amount: 15.0, status: 'PENDING')
        allow(TransactionRepository::LOGGER).to receive(:info) 

        updated_transaction = TransactionRepository.update_status(transaction.id, 'COMPLETED', 'PAY-1234')

        expect(updated_transaction.status).to eq('COMPLETED')
        expect(updated_transaction.payment_id).to eq('PAY-1234')
        expect(TransactionRepository::LOGGER).to have_received(:info).with("[UPDATE_STATUS] Transacción actualizada: ID=#{transaction.id}, Nuevo estado=COMPLETED")
      end
    end

    context 'when the transaction does not exist' do
      it 'raises an error and logs the event' do
        allow(TransactionRepository::LOGGER).to receive(:error) 

        expect {
          TransactionRepository.update_status(999, 'FAILED', nil, 'Error de pago')
        }.to raise_error(StandardError, 'Transacción con ID 999 no encontrada')

        expect(TransactionRepository::LOGGER).to have_received(:error).with("[UPDATE_STATUS] Excepción al actualizar la transacción: Transacción con ID 999 no encontrada")
      end
    end

    context 'when the transaction is invalid' do
      it 'raises an error and logs the event' do
        transaction = Transaction.create!(transaction_number: 'TXN-1234', quantity: 2, base_fee: 10.0, delivery_fee: 5.0, total_amount: 15.0, status: 'PENDING')
        allow(TransactionRepository::LOGGER).to receive(:error) 

        expect {
          TransactionRepository.update_status(transaction.id, nil)
        }.to raise_error(StandardError)

        expect(TransactionRepository::LOGGER).to have_received(:error).with(/Error al actualizar la transacción:/)
      end
    end
  end
end
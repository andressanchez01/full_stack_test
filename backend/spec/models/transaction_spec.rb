require 'spec_helper'
require_relative '../../app/models/transaction'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      transaction = Transaction.new(
        transaction_number: 'TXN-20250408-ABCD',
        quantity: 2,
        base_fee: 10.0,
        delivery_fee: 5.0,
        total_amount: 15.0,
        status: 'PENDING',
        payment_id: nil
      )
      expect(transaction).to be_valid
    end

    it 'is invalid without a transaction number' do
      transaction = Transaction.new(quantity: 2, base_fee: 10.0, delivery_fee: 5.0, total_amount: 15.0, status: 'PENDING')
      allow(transaction).to receive(:generate_transaction_number) # Desactiva el callback
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_number]).to include("can't be blank")
    end

    it 'requires a payment_id if the status is COMPLETED' do
      transaction = Transaction.new(
        quantity: 2,
        base_fee: 10.0,
        delivery_fee: 5.0,
        total_amount: 15.0,
        status: 'COMPLETED',
        payment_id: nil
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:payment_id]).to include("can't be blank")
    end
  end

  describe 'callbacks' do
    it 'generates a transaction number before validation' do
      transaction = Transaction.new(
        quantity: 2,
        base_fee: 10.0,
        delivery_fee: 5.0,
        total_amount: 15.0,
        status: 'PENDING'
      )
      transaction.valid?
      expect(transaction.transaction_number).to match(/^TXN-\d{14}-[A-Z0-9]{4}$/)
    end

    it 'logs validation errors after validation' do
      transaction = Transaction.new(
        quantity: nil,
        base_fee: 10.0,
        delivery_fee: 5.0,
        total_amount: 15.0,
        status: 'PENDING'
      )
      allow(Transaction::LOGGER).to receive(:warn) # Simula el logger
      transaction.valid?
      expect(Transaction::LOGGER).to have_received(:warn).with(/Errores de validación: Quantity can't be blank/)
    end

    it 'logs status changes after update' do
      transaction = Transaction.create!(
        transaction_number: 'TXN-20250408-ABCD',
        quantity: 2,
        base_fee: 10.0,
        delivery_fee: 5.0,
        total_amount: 15.0,
        status: 'PENDING'
      )
      allow(Transaction::LOGGER).to receive(:info) # Simula el logger
      transaction.update!(status: 'COMPLETED', payment_id: 'PAY-1234') # Proporciona un payment_id
      expect(Transaction::LOGGER).to have_received(:info).with("[TRANSACTION] Estado de la transacción actualizado: ID #{transaction.id}, Nuevo estado: COMPLETED")
    end
  end
end
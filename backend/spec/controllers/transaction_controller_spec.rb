require 'spec_helper'
require_relative '../../app/controllers/transaction_controller'
require_relative '../../app/repositories/transaction_repository'
require_relative '../../app/models/transaction'
require_relative '../../app/services/result'

RSpec.describe TransactionController do
  describe '.create' do
    let(:params) { { product_id: 1, quantity: 2, customer: { name: 'John Doe', email: 'john@example.com' } } }

    it 'returns success when creation is successful' do
      transaction = double(:transaction)
      allow(TransactionService).to receive(:create_transaction).with(params).and_return(Result.success(transaction))

      response = described_class.create(params)

      expect(response[:status]).to eq('success')
      expect(response[:data]).to eq(transaction)
    end

    it 'returns error when creation fails' do
      allow(TransactionService).to receive(:create_transaction).with(params).and_return(Result.failure('Invalid product'))

      response = described_class.create(params)

      expect(response[:status]).to eq('error')
      expect(response[:message]).to eq('Invalid product')
    end
  end

  describe '.update' do
    let(:transaction_id) { 123 }

    context 'when status is COMPLETED' do
      let(:params) { { status: 'COMPLETED', card_data: { card_number: '1234' } } }

      it 'processes the payment and returns success' do
        result = double(:result)
        allow(TransactionService).to receive(:process_payment).with(transaction_id, params[:card_data]).and_return(Result.success(result))

        response = described_class.update(transaction_id, params)

        expect(response[:status]).to eq('success')
        expect(response[:data]).to eq(result)
      end

      it 'returns error if card data is missing' do
        response = described_class.update(transaction_id, { status: 'COMPLETED' })

        expect(response[:status]).to eq('error')
        expect(response[:message]).to eq('Missing card data for payment processing')
      end
    end

    context 'when status is FAILED' do
      let(:params) { { status: 'FAILED', reason: 'Insufficient funds' } }

      it 'marks the transaction as failed with a reason' do
        failed_result = double(:failed_result)
        allow(TransactionService).to receive(:mark_transaction_failed).with(transaction_id, 'Insufficient funds').and_return(Result.success(failed_result))

        response = described_class.update(transaction_id, params)

        expect(response[:status]).to eq('success')
        expect(response[:data]).to eq(failed_result)
      end

      it 'uses default reason if none is provided' do
        allow(TransactionService).to receive(:mark_transaction_failed).with(transaction_id, 'Unknown error').and_return(Result.success('marked'))

        response = described_class.update(transaction_id, { status: 'FAILED' })

        expect(response[:status]).to eq('success')
        expect(response[:data]).to eq('marked')
      end
    end

    context 'when status is invalid' do
      it 'returns error' do
        response = described_class.update(transaction_id, { status: 'INVALID' })

        expect(response[:status]).to eq('error')
        expect(response[:message]).to eq('Invalid transaction status')
      end
    end

    context 'when id or status is missing' do
      it 'returns error if id is nil' do
        response = described_class.update(nil, { status: 'COMPLETED' })

        expect(response[:status]).to eq('error')
        expect(response[:message]).to eq('Missing required params')
      end

      it 'returns error if status is nil' do
        response = described_class.update(transaction_id, {})

        expect(response[:status]).to eq('error')
        expect(response[:message]).to eq('Missing required params')
      end
    end
  end
end

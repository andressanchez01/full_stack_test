require 'spec_helper'
require 'webmock/rspec'
require_relative '../../app/services/transaction_service'
require_relative '../../app/services/payment_service'
require_relative '../../app/services/result'
require_relative '../../app/repositories/product_repository'
require_relative '../../app/repositories/customer_repository'
require_relative '../../app/repositories/transaction_repository'

RSpec.describe TransactionService do
  let(:product) { double('Product', id: 1, price: 100000, stock_quantity: 10) }
  let(:customer) { double('Customer', id: 1) }
  let(:transaction) { double('Transaction', id: 1, product_id: 1, quantity: 2) }

  let(:params) do
    {
      product_id: product.id,
      quantity: 2,
      customer: {
        name: 'Test User',
        email: 'test@example.com',
        phone: '1234567890',
        address: '123 Main St'
      }
    }
  end

  describe '.create_transaction' do
    it 'returns success when product and customer are valid' do
      allow(ProductRepository).to receive(:find_by_id).and_return(Result.success(product))
      allow(CustomerRepository).to receive(:create_or_find).and_return(Result.success(customer))
      allow(TransactionRepository).to receive(:create).and_return(Result.success(transaction))

      result = TransactionService.create_transaction(params)

      expect(result).to be_success
      expect(result.value).to eq(transaction)
    end

    it 'returns failure if product is not found' do
      allow(ProductRepository).to receive(:find_by_id).and_return(Result.failure('Not found'))

      result = TransactionService.create_transaction(params)

      expect(result).to be_failure
      expect(result.error).to eq('Not found')
    end

    it 'returns failure if customer creation fails' do
      allow(ProductRepository).to receive(:find_by_id).and_return(Result.success(product))
      allow(CustomerRepository).to receive(:create_or_find).and_return(Result.failure('Invalid email'))

      result = TransactionService.create_transaction(params)

      expect(result).to be_failure
      expect(result.error).to eq('Invalid email')
    end
  end

  describe '.process_payment' do
    let(:card_data) do
      {
        number: '4111111111111111',
        exp_month: '12',
        exp_year: '30',
        cvc: '123',
        card_holder: 'Test User'
      }
    end

    it 'completes transaction when payment succeeds' do
      allow(TransactionRepository).to receive(:find_by_id).and_return(Result.success(transaction))
      allow(PaymentService).to receive(:process_payment).and_return(Result.success({ 'id' => 'pay_123', 'status' => 'APPROVED' }))
      allow(TransactionRepository).to receive(:update_status).and_return(Result.success(transaction))
      allow(ProductRepository).to receive(:update_stock).and_return(Result.success(product))

      result = TransactionService.process_payment(transaction.id, card_data)

      expect(result).to be_success
    end

    it 'returns failure if payment fails' do
      allow(TransactionRepository).to receive(:find_by_id).and_return(Result.success(transaction))
      allow(PaymentService).to receive(:process_payment).and_return(Result.failure('Card declined'))

      result = TransactionService.process_payment(transaction.id, card_data)

      expect(result).to be_failure
      expect(result.error).to eq('Card declined')
    end
  end

  describe '.mark_transaction_failed' do
    it 'updates transaction with FAILED status and reason' do
      expect(TransactionRepository).to receive(:update_status).with(transaction.id, 'FAILED', nil, 'Insufficient funds')

      TransactionService.mark_transaction_failed(transaction.id, 'Insufficient funds')
    end
  end
end

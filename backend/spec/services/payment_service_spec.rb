require 'spec_helper'
require 'webmock/rspec'
require_relative '../../app/services/payment_service'
require_relative '../../app/services/result'
require_relative '../../app/services/payment_status_service'

RSpec.describe PaymentService do
  let(:transaction) do
    double(
      'Transaction',
      total_amount: 100.0,
      transaction_number: 'TX12345',
      customer: double('Customer', email: 'customer@example.com')
    )
  end

  let(:card_data) do
    {
      number: '4111111111111111',
      expiration_month: '12',
      expiration_year: '2030',
      cvc: '123'
    }
  end

  before do
    stub_const("PaymentService::PROVIDER_API_URL", "https://api.provider.com")
    stub_const("PaymentService::PROVIDER_PUBLIC_KEY", "public_key")
    stub_const("PaymentService::PROVIDER_PRIVATE_KEY", "private_key")
    stub_const("PaymentService::PROVIDER_INTEGRITY_KEY", "integrity_key")
  end

  describe '.process_payment' do
    context 'when the payment is successful' do
      it 'returns a success result' do
        allow(PaymentService).to receive(:fetch_acceptance_token).and_return('acceptance_token')
        allow(PaymentService).to receive(:create_card_token).and_return('card_token')
        allow(PaymentService).to receive(:create_transaction).and_return(Result.success({ id: 'transaction_id', status: 'APPROVED' }))

        result = PaymentService.process_payment(transaction, card_data)

        expect(result).to be_success
        expect(result.value[:id]).to eq('transaction_id')
      end
    end

    context 'when the card token creation fails' do
      it 'returns a failure result' do
        allow(PaymentService).to receive(:fetch_acceptance_token).and_return('acceptance_token')
        allow(PaymentService).to receive(:create_card_token).and_return(nil)

        result = PaymentService.process_payment(transaction, card_data)

        expect(result).to be_failure
        expect(result.error).to eq('Failed to create card token')
      end
    end
  end

  describe '.fetch_acceptance_token' do
    it 'returns the acceptance token' do
      response_body = { data: { presigned_acceptance: { acceptance_token: 'acceptance_token' } } }.to_json
      stub_request(:get, "https://api.provider.com/merchants/public_key").to_return(body: response_body)

      token = PaymentService.fetch_acceptance_token

      expect(token).to eq('acceptance_token')
    end

    it 'returns nil if an error occurs' do
      stub_request(:get, "https://api.provider.com/merchants/public_key").to_raise(StandardError.new('Network error'))

      token = PaymentService.fetch_acceptance_token

      expect(token).to be_nil
    end
  end

  describe '.create_card_token' do
    it 'returns the card token' do
      response_body = { data: { id: 'card_token' } }.to_json
      stub_request(:post, "https://api.provider.com/tokens/cards")
        .with(body: card_data.to_json)
        .to_return(body: response_body)

      token = PaymentService.create_card_token(card_data)

      expect(token).to eq('card_token')
    end

    it 'returns nil if an error occurs' do
      stub_request(:post, "https://api.provider.com/tokens/cards").to_raise(StandardError.new('Network error'))

      token = PaymentService.create_card_token(card_data)

      expect(token).to be_nil
    end
  end

  describe '.create_transaction' do
    it 'returns a success result when the transaction is approved' do
      response_body = { data: { id: 'trx123', status: 'APPROVED' } }.to_json
      stub_request(:post, "https://api.provider.com/transactions")
        .to_return(body: response_body)

      result = PaymentService.create_transaction(transaction, 'card_token', 'acceptance_token')

      expect(result).to be_success
      expect(result.value['id']).to eq('trx123')
    end

    it 'returns a failure result when the transaction fails' do
      response_body = { error: { message: 'Payment failed' } }.to_json
      stub_request(:post, "https://api.provider.com/transactions")
        .to_return(body: response_body)

      result = PaymentService.create_transaction(transaction, 'card_token', 'acceptance_token')

      expect(result).to be_failure
      expect(result.error).to eq('Payment failed')
    end
  end
end
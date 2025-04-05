
require 'spec_helper'
require 'dotenv/load'
require_relative '../../app/services/payment_service'
require_relative '../../app/services/result'

RSpec.describe PaymentService do
    let(:customer) { double('Customer', email: 'test@example.com', name: 'Test User') }
    let(:transaction) { double('Transaction', transaction_number: 'TXN123_APPROVED', total_amount: 300000, customer: customer) }
    let(:card_data) do
        {
            number: '4242424242424242',
            cvc: '123',
            exp_month: '12',
            exp_year: '30',
            card_holder: 'Test User'
        }
    end

    describe '.process_payment' do
        context 'when transaction is approved' do
            before do
                allow(PaymentService).to receive(:fetch_acceptance_token).and_return("fake_acceptance_token")
                allow(PaymentService).to receive(:create_card_token).with(card_data).and_return("fake_card_token")

                approved_result = Result.success({
                "status" => "APPROVED",
                "id" => "trans_123",
                "reference" => transaction.transaction_number
                })
                allow(PaymentService).to receive(:create_transaction).and_return(approved_result)
            end

            it 'returns a successful result' do
                result = PaymentService.process_payment(transaction, card_data)
                expect(result).to be_success
                expect(result.value["status"]).to eq("APPROVED")
            end
        end

        context 'when transaction is declined' do
            before do
                allow(PaymentService).to receive(:fetch_acceptance_token).and_return("fake_acceptance_token")
                allow(PaymentService).to receive(:create_card_token).with(card_data).and_return("fake_card_token")

                declined_result = Result.failure("Transaction declined")
                allow(PaymentService).to receive(:create_transaction).and_return(declined_result)
            end

            it 'returns a failure result' do
                result = PaymentService.process_payment(transaction, card_data)
                expect(result).not_to be_success
                expect(result.error).to eq("Transaction declined")
            end
        end

        context 'when card token generation fails' do
            before do
                allow(PaymentService).to receive(:fetch_acceptance_token).and_return("fake_acceptance_token")
                allow(PaymentService).to receive(:create_card_token).with(card_data).and_return(nil)
            end

            it 'returns a failure result for card token generation' do
                result = PaymentService.process_payment(transaction, card_data)
                expect(result).not_to be_success
                expect(result.error).to eq("Failed to create card token")
            end
        end
    end
end

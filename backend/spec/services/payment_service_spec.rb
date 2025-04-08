require 'spec_helper'
require 'net/http'
require 'uri'
require 'json'
require_relative '../../app/services/payment_service'
require_relative '../../app/models/transaction'
require_relative '../../app/models/customer'

RSpec.describe PaymentService, type: :service do
  let(:customer) do
    Customer.create!(
      name: 'John Doe',
      email: 'customer@example.com',
      phone: '123456789', 
      address: '123 Main St' 
    )
  end

  let(:transaction) do
    Transaction.new(
      transaction_number: 'TXN-1234',
      total_amount: 100.0,
      customer: customer
    )
  end

  let(:card_data) do
    {
      cardNumber: '4111111111111111',
      cardHolder: 'John Doe',
      expiryMonth: '12',
      expiryYear: '2030',
      cvv: '123'
    }
  end

  describe '.process_payment' do
    context 'when the payment is successful' do
      it 'processes the payment and logs the event' do
        allow(PaymentService).to receive(:fetch_acceptance_token).and_return('acceptance_token')
        allow(PaymentService).to receive(:create_card_token).and_return('card_token')
        allow(PaymentService).to receive(:create_transaction).and_return({ id: 'transaction_id', status: 'APPROVED' })
        allow(PaymentService::LOGGER).to receive(:info)

        result = PaymentService.process_payment(transaction, card_data)

        expect(result).to eq({ id: 'transaction_id', status: 'APPROVED' })
        expect(PaymentService::LOGGER).to have_received(:info).with("[PROCESS_PAYMENT] Datos de tarjeta formateados correctamente")
      end
    end

    context 'when the card data is incomplete' do
      it 'raises an error and logs the event' do
        incomplete_card_data = card_data.merge(cardNumber: nil)
        allow(PaymentService::LOGGER).to receive(:error)

        expect {
          PaymentService.process_payment(transaction, incomplete_card_data)
        }.to raise_error(StandardError, /Datos de la tarjeta incompletos/)

        expect(PaymentService::LOGGER).to have_received(:error).with(/Error al procesar el pago:/)
      end
    end

    context 'when an error occurs during processing' do
      it 'raises an error and logs the event' do
        allow(PaymentService).to receive(:fetch_acceptance_token).and_raise(StandardError, 'Token error')
        allow(PaymentService::LOGGER).to receive(:error)

        expect {
          PaymentService.process_payment(transaction, card_data)
        }.to raise_error(StandardError, 'Token error')

        expect(PaymentService::LOGGER).to have_received(:error).with("[PROCESS_PAYMENT] Error al procesar el pago: Token error")
      end
    end
  end

  describe '.fetch_acceptance_token' do
    context 'when the token is fetched successfully' do
      it 'returns the token and logs the event' do
        response_body = { data: { presigned_acceptance: { acceptance_token: 'acceptance_token' } } }.to_json
        allow(Net::HTTP).to receive(:get).and_return(response_body)
        allow(PaymentService::LOGGER).to receive(:info)

        token = PaymentService.fetch_acceptance_token

        expect(token).to eq('acceptance_token')
        expect(PaymentService::LOGGER).to have_received(:info).with("[FETCH_ACCEPTANCE_TOKEN] Token de aceptación obtenido correctamente")
      end
    end

    context 'when an error occurs' do
      it 'logs the error and returns nil' do
        allow(Net::HTTP).to receive(:get).and_raise(StandardError, 'Network error')
        allow(PaymentService::LOGGER).to receive(:error)

        token = PaymentService.fetch_acceptance_token

        expect(token).to be_nil
        expect(PaymentService::LOGGER).to have_received(:error).with("[FETCH_ACCEPTANCE_TOKEN] Error al obtener el token de aceptación: Network error")
      end
    end
  end

  describe '.create_card_token' do
    context 'when the card token is created successfully' do
      it 'returns the card token and logs the event' do
        response_body = { data: { id: 'card_token' } }.to_json
        allow(Net::HTTP).to receive(:start).and_return(double(body: response_body))
        allow(PaymentService::LOGGER).to receive(:info)

        token = PaymentService.create_card_token(card_data)

        expect(token).to eq('card_token')
        expect(PaymentService::LOGGER).to have_received(:info).with("[CREATE_CARD_TOKEN] Token de tarjeta creado correctamente: card_token")
      end
    end

    context 'when an error occurs' do
      it 'raises an error and logs the event' do
        response_body = { error: { message: 'Invalid card data' } }.to_json
        allow(Net::HTTP).to receive(:start).and_return(double(body: response_body))
        allow(PaymentService::LOGGER).to receive(:error)

        expect {
          PaymentService.create_card_token(card_data)
        }.to raise_error(StandardError, 'Invalid card data')

        expect(PaymentService::LOGGER).to have_received(:error).with("[CREATE_CARD_TOKEN] Invalid card data")
      end
    end
  end

  describe '.create_transaction' do
    context 'when the transaction is created successfully' do
      it 'returns the transaction data and logs the event' do
        response_body = { data: { id: 'transaction_id', status: 'APPROVED' } }.to_json
        allow(Net::HTTP).to receive(:start).and_return(double(body: response_body))
        allow(PaymentService::LOGGER).to receive(:info)

        result = PaymentService.create_transaction(transaction, 'card_token', 'acceptance_token')

        expect(result['id']).to eq('transaction_id')
        expect(result['status']).to eq('APPROVED')
        expect(PaymentService::LOGGER).to have_received(:info).with("[CREATE_TRANSACTION] Creando transacción para el pago")
      end
    end

    context 'when an error occurs' do
      it 'raises an error and logs the event' do
        response_body = { error: { message: 'Transaction failed' } }.to_json
        allow(Net::HTTP).to receive(:start).and_return(double(body: response_body))
        allow(PaymentService::LOGGER).to receive(:error)

        expect {
          PaymentService.create_transaction(transaction, 'card_token', 'acceptance_token')
        }.to raise_error(StandardError, 'Transaction failed')

        expect(PaymentService::LOGGER).to have_received(:error).with("[CREATE_TRANSACTION] Transaction failed")
      end
    end
  end
end
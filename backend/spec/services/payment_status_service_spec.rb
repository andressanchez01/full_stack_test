require 'spec_helper'
require 'net/http'
require 'uri'
require 'json'
require_relative '../../app/services/payment_status_service'

RSpec.describe PaymentStatusService, type: :service do
  let(:transaction_id) { '12345' }
  let(:provider_api_url) { 'https://api.provider.com' }

  before do
    stub_const('PaymentStatusService::PROVIDER_API_URL', provider_api_url)
  end

  describe '.poll_transaction_status' do
    context 'when the transaction reaches a final status' do
      it 'returns the final status and logs the event' do
        allow(PaymentStatusService).to receive(:fetch_transaction_status).and_return('APPROVED')
        allow(PaymentStatusService::LOGGER).to receive(:info)

        status = PaymentStatusService.poll_transaction_status(transaction_id)

        expect(status).to eq('APPROVED')
        expect(PaymentStatusService::LOGGER).to have_received(:info).with("[POLL_TRANSACTION_STATUS] Estado final alcanzado: APPROVED (ID=#{transaction_id})")
      end
    end

    context 'when the transaction times out' do
      it 'returns TIMEOUT and logs the event' do
        allow(PaymentStatusService).to receive(:fetch_transaction_status).and_return(nil)
        allow(PaymentStatusService::LOGGER).to receive(:warn)

        status = PaymentStatusService.poll_transaction_status(transaction_id, max_attempts: 3, interval: 0)

        expect(status).to eq('TIMEOUT')
        expect(PaymentStatusService::LOGGER).to have_received(:warn).with("[POLL_TRANSACTION_STATUS] Tiempo de espera agotado para la transacción ID=#{transaction_id}")
      end
    end
  end

  describe '.fetch_transaction_status' do
    let(:uri) { URI("#{provider_api_url}/transactions/#{transaction_id}") }

    context 'when the request is successful' do
      it 'returns the transaction status and logs the event' do
        response_body = { data: { status: 'PENDING' } }.to_json
        allow(Net::HTTP).to receive(:get_response).and_return(double(body: response_body, is_a?: true))
        allow(PaymentStatusService::LOGGER).to receive(:info)

        status = PaymentStatusService.fetch_transaction_status(transaction_id)

        expect(status).to eq('PENDING')
        expect(PaymentStatusService::LOGGER).to have_received(:info).with("[FETCH_TRANSACTION_STATUS] Estado obtenido: PENDING (ID=#{transaction_id})")
      end
    end

    context 'when the server returns an error' do
      it 'logs the error and returns nil' do
        allow(Net::HTTP).to receive(:get_response).and_return(double(code: '500', is_a?: false))
        allow(PaymentStatusService::LOGGER).to receive(:error)

        status = PaymentStatusService.fetch_transaction_status(transaction_id)

        expect(status).to be_nil
        expect(PaymentStatusService::LOGGER).to have_received(:error).with("[FETCH_TRANSACTION_STATUS] Error al obtener el estado: Código 500 (ID=#{transaction_id})")
      end
    end

    context 'when too many requests are made' do
        it 'raises an error and logs the event' do
          allow(Net::HTTP).to receive(:get_response).and_return(double(code: '429', is_a?: false))
          allow(PaymentStatusService::LOGGER).to receive(:error)
      
          expect {
            PaymentStatusService.fetch_transaction_status(transaction_id)
          }.to raise_error(StandardError, "Demasiadas solicitudes al servidor (ID=#{transaction_id})")
      
          expect(PaymentStatusService::LOGGER).to have_received(:error).with("[FETCH_TRANSACTION_STATUS] Demasiadas solicitudes al servidor (ID=#{transaction_id})")
        end
      end
  end

  describe '.final_status?' do
    it 'returns true for a final status' do
      expect(PaymentStatusService.final_status?('APPROVED')).to be true
      expect(PaymentStatusService.final_status?('DECLINED')).to be true
      expect(PaymentStatusService.final_status?('VOIDED')).to be true
      expect(PaymentStatusService.final_status?('ERROR')).to be true
    end

    it 'returns false for a non-final status' do
      expect(PaymentStatusService.final_status?('PENDING')).to be false
      expect(PaymentStatusService.final_status?('PROCESSING')).to be false
      expect(PaymentStatusService.final_status?(nil)).to be false
    end
  end
end
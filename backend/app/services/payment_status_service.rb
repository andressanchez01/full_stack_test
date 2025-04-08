require 'net/http'
require 'uri'
require 'json'
require 'logger'

class PaymentStatusService
  PROVIDER_API_URL = ENV['PROVIDER_API_URL']
  LOGGER = Logger.new(STDOUT) 

  def self.poll_transaction_status(transaction_id, max_attempts: 10, interval: 5)
    attempts = 0

    loop do
      attempts += 1
      status = fetch_transaction_status(transaction_id)

      if final_status?(status)
        LOGGER.info("[POLL_TRANSACTION_STATUS] Estado final alcanzado: #{status} (ID=#{transaction_id})")
        return status
      elsif attempts >= max_attempts
        LOGGER.warn("[POLL_TRANSACTION_STATUS] Tiempo de espera agotado para la transacción ID=#{transaction_id}")
        return 'TIMEOUT'
      else
        LOGGER.info("[POLL_TRANSACTION_STATUS] Estado actual: #{status || 'DESCONOCIDO'}. Reintentando en #{interval} segundos... (Intento #{attempts}/#{max_attempts})")
        sleep(interval)
      end
    end
  end

  def self.fetch_transaction_status(transaction_id)
    url = "#{PROVIDER_API_URL}/transactions/#{transaction_id}"
    uri = URI(url)
  
    begin
      response = Net::HTTP.get_response(uri)
      LOGGER.info("[FETCH_TRANSACTION_STATUS] Solicitud GET a #{uri} (ID=#{transaction_id})")
  
      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        status = data.dig('data', 'status')
        LOGGER.info("[FETCH_TRANSACTION_STATUS] Estado obtenido: #{status} (ID=#{transaction_id})")
        return status
      elsif response.code.to_i == 429 
        LOGGER.error("[FETCH_TRANSACTION_STATUS] Demasiadas solicitudes al servidor (ID=#{transaction_id})")
        raise StandardError, "Demasiadas solicitudes al servidor (ID=#{transaction_id})"
      else
        LOGGER.error("[FETCH_TRANSACTION_STATUS] Error al obtener el estado: Código #{response.code} (ID=#{transaction_id})")
        return nil
      end
    rescue StandardError => e
      LOGGER.error("[FETCH_TRANSACTION_STATUS] Excepción: #{e.message} (ID=#{transaction_id})")
      raise e
    end
  end

  def self.final_status?(status)
    %w[APPROVED DECLINED VOIDED ERROR].include?(status)
  end
end
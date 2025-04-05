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
                return status
            elsif attempts >= max_attempts
                return 'TIMEOUT'
            else
                sleep(interval)
            end
        end
    end

    def self.fetch_transaction_status(transaction_id)
        url = "#{PROVIDER_API_URL}/transactions/#{transaction_id}"
        uri = URI(url)
      
        attempts = 0
        max_attempts = 5
      
        begin
            response = Net::HTTP.get_response(uri)
            LOGGER.info("Solicitud GET a #{uri}")
            LOGGER.info("Código de respuesta: #{response.code}")
            LOGGER.info("Cuerpo de la respuesta: #{response.body}")
        
            if response.is_a?(Net::HTTPSuccess)
                data = JSON.parse(response.body)
                status = data.dig('data', 'status')
                LOGGER.info("Estado de la transacción: #{status}")
                return status
            elsif response.code.to_i == 429  # Too Many Requests
                raise "Too many requests"
            else
                LOGGER.error("Error al obtener el estado de la transacción: Código #{response.code}")
                return nil
            end
        rescue => e
            attempts += 1
            LOGGER.error("Excepción: #{e.message}")
            if attempts < max_attempts
                LOGGER.warn("Reintentando en 10 segundos... (intento #{attempts})")
                sleep(10)
                retry
            else
                LOGGER.error("Número máximo de reintentos alcanzado")
                return nil
            end
        end
      end
      

    def self.final_status?(status)
        %w[APPROVED DECLINED VOIDED ERROR].include?(status)
    end
end
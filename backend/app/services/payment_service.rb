require 'net/http'
require 'uri'
require 'json'
require 'digest'
require 'logger'
require_relative 'payment_status_service'

class PaymentService
  LOGGER = Logger.new(STDOUT) 
  PROVIDER_API_URL = ENV['PROVIDER_API_URL'] || ENV['SANDBOX_API_URL']
  PROVIDER_PUBLIC_KEY = ENV['PROVIDER_PUBLIC_KEY']
  PROVIDER_PRIVATE_KEY = ENV['PROVIDER_PRIVATE_KEY']

  def self.process_payment(transaction, card_data)
    begin
      formatted_card_data = {
        number: card_data[:cardNumber],
        card_holder: card_data[:cardHolder],
        exp_month: card_data[:expiryMonth],
        exp_year: card_data[:expiryYear],
        cvc: card_data[:cvv]
      }

      LOGGER.info("[PROCESS_PAYMENT] Datos de tarjeta formateados correctamente")

      required_fields = %w[number card_holder exp_month exp_year cvc]
      missing_fields = required_fields.select { |field| formatted_card_data[field.to_sym].nil? || formatted_card_data[field.to_sym].strip.empty? }

      unless missing_fields.empty?
        raise StandardError, "Datos de la tarjeta incompletos: faltan los campos #{missing_fields.join(', ')}"
      end

      acceptance_token = fetch_acceptance_token
      raise StandardError, "No se pudo obtener el token de aceptación" if acceptance_token.nil?

      card_token = create_card_token(formatted_card_data)
      raise StandardError, "No se pudo crear el token de la tarjeta" if card_token.nil?

      create_transaction(transaction, card_token, acceptance_token)
    rescue StandardError => e
      LOGGER.error("[PROCESS_PAYMENT] Error al procesar el pago: #{e.message}")
      raise e
    end
  end

  def self.fetch_acceptance_token
    url = "#{PROVIDER_API_URL}/merchants/#{PROVIDER_PUBLIC_KEY}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)["data"]
    token = data.dig("presigned_acceptance", "acceptance_token") if data
    LOGGER.info("[FETCH_ACCEPTANCE_TOKEN] Token de aceptación obtenido correctamente") if token
    token
  rescue StandardError => e
    LOGGER.error("[FETCH_ACCEPTANCE_TOKEN] Error al obtener el token de aceptación: #{e.message}")
    nil
  end

  def self.create_card_token(card_data)
    url = "#{PROVIDER_API_URL}/tokens/cards"
    uri = URI(url)
    headers = {
      "Authorization" => "Bearer #{PROVIDER_PUBLIC_KEY}",
      "Content-Type" => "application/json"
    }

    LOGGER.info("[CREATE_CARD_TOKEN] Creando token de tarjeta")

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Post.new(uri, headers)
      request.body = card_data.to_json
      http.request(request)
    end

    result = JSON.parse(response.body)

    if result["data"] && result["data"]["id"]
      LOGGER.info("[CREATE_CARD_TOKEN] Token de tarjeta creado correctamente: #{result['data']['id']}")
      result["data"]["id"]
    else
      error_message = result["error"] ? result["error"]["message"] : "Error desconocido al crear el token de la tarjeta"
      LOGGER.error("[CREATE_CARD_TOKEN] #{error_message}")
      raise StandardError, error_message
    end
  rescue StandardError => e
    LOGGER.error("[CREATE_CARD_TOKEN] Excepción al crear el token de la tarjeta: #{e.message}")
    raise e
  end

  def self.generate_signature(amount_in_cents, currency, reference)
    integrity_key = ENV['PROVIDER_INTEGRITY_KEY']
    plain_signature = "#{reference}#{amount_in_cents}#{currency}#{integrity_key}"
    Digest::SHA256.hexdigest(plain_signature)
  end

  def self.create_transaction(transaction, card_token, acceptance_token)
    url = "#{PROVIDER_API_URL}/transactions"
    uri = URI(url)
    headers = {
      "Authorization" => "Bearer #{PROVIDER_PRIVATE_KEY}",
      "Content-Type" => "application/json"
    }

    amount_in_cents = (transaction.total_amount * 100).to_i
    reference = transaction.transaction_number

    body = {
      acceptance_token: acceptance_token,
      amount_in_cents: amount_in_cents,
      currency: "COP",
      signature: generate_signature(amount_in_cents, "COP", reference),
      customer_email: transaction.customer.email,
      payment_method: {
        type: "CARD",
        token: card_token,
        installments: 1
      },
      reference: reference
    }.to_json

    LOGGER.info("[CREATE_TRANSACTION] Creando transacción para el pago")

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Post.new(uri, headers)
      request.body = body
      http.request(request)
    end

    parsed_response = JSON.parse(response.body)

    if parsed_response['data']
      transaction_id = parsed_response['data']['id']
      status = parsed_response["data"]["status"]

      if status == "PENDING"
        status = PaymentStatusService.poll_transaction_status(transaction_id)
      end

      case status
      when 'APPROVED'
        LOGGER.info("[CREATE_TRANSACTION] Pago aprobado: #{parsed_response['data'].inspect}")
        parsed_response['data']
      when 'DECLINED', 'VOIDED', 'ERROR'
        raise StandardError, "El pago falló con el estado: #{status}"
      else
        raise StandardError, "Estado de pago desconocido: #{status}"
      end
    else
      error_message = parsed_response['error'] ? parsed_response['error']['message'] : 'El pago falló'
      LOGGER.error("[CREATE_TRANSACTION] #{error_message}")
      raise StandardError, error_message
    end
  rescue StandardError => e
    LOGGER.error("[CREATE_TRANSACTION] Error al crear la transacción: #{e.message}")
    raise e
  end
end
require 'net/http'
require 'uri'
require 'json'
require 'digest'
require_relative 'payment_status_service'

class PaymentService
  PROVIDER_API_URL = ENV['PROVIDER_API_URL'] || ENV['SANDBOX_API_URL']
  PROVIDER_PUBLIC_KEY = ENV['PROVIDER_PUBLIC_KEY']
  PROVIDER_PRIVATE_KEY = ENV['PROVIDER_PRIVATE_KEY']

  def self.process_payment(transaction, card_data)
    begin
      # Mapea las claves del frontend a las claves esperadas por la API
      formatted_card_data = {
        number: card_data[:cardNumber],
        card_holder: card_data[:cardHolder],
        exp_month: card_data[:expiryMonth],
        exp_year: card_data[:expiryYear],
        cvc: card_data[:cvv]
      }
  
      puts "🪵 [PROCESS_PAYMENT] Datos formateados: #{formatted_card_data.inspect}"
  
      # Valida que los datos de la tarjeta estén completos
      required_fields = %w[number card_holder exp_month exp_year cvc]
      missing_fields = required_fields.select { |field| formatted_card_data[field.to_sym].nil? || formatted_card_data[field.to_sym].strip.empty? }
  
      unless missing_fields.empty?
        raise StandardError, "Datos de la tarjeta incompletos: faltan los campos #{missing_fields.join(', ')}"
      end
  
      # Obtén el token de aceptación
      acceptance_token = fetch_acceptance_token
      raise StandardError, "Failed to fetch acceptance token" if acceptance_token.nil?
  
      # Crea el token de la tarjeta utilizando los datos formateados
      card_token = create_card_token(formatted_card_data)
      raise StandardError, "Failed to create card token" if card_token.nil?
  
      # Crea la transacción
      create_transaction(transaction, card_token, acceptance_token)
    rescue StandardError => e
      puts "❌ [PROCESS_PAYMENT] Error al procesar el pago: #{e.message}"
      raise e
    end
  end

  def self.fetch_acceptance_token
    url = "#{PROVIDER_API_URL}/merchants/#{PROVIDER_PUBLIC_KEY}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)["data"]
    data.dig("presigned_acceptance", "acceptance_token") if data
  rescue StandardError => e
    puts "❌ [FETCH_ACCEPTANCE_TOKEN] Error al obtener el token de aceptación: #{e.message}"
    nil
  end

  def self.create_card_token(card_data)
    url = "#{PROVIDER_API_URL}/tokens/cards"
    uri = URI(url)
    headers = {
      "Authorization" => "Bearer #{PROVIDER_PUBLIC_KEY}",
      "Content-Type" => "application/json"
    }
  
    puts "🪵 [CREATE_CARD_TOKEN] URL: #{url}"
    puts "🪵 [CREATE_CARD_TOKEN] Headers: #{headers.inspect}"
    puts "🪵 [CREATE_CARD_TOKEN] Body: #{card_data.to_json}"
  
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Post.new(uri, headers)
      request.body = card_data.to_json
      http.request(request)
    end
  
    result = JSON.parse(response.body)
  
    if result["data"] && result["data"]["id"]
      puts "✅ [CREATE_CARD_TOKEN] Token de tarjeta creado: #{result['data']['id']}"
      result["data"]["id"]
    else
      error_message = result["error"] ? result["error"]["message"] : "Error desconocido al crear el token de la tarjeta"
      puts "❌ [CREATE_CARD_TOKEN] Error al crear el token de la tarjeta: #{error_message}"
      raise StandardError, error_message
    end
  rescue StandardError => e
    puts "❌ [CREATE_CARD_TOKEN] Excepción al crear el token de la tarjeta: #{e.message}"
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
        puts "✅ [CREATE_TRANSACTION] Pago aprobado: #{parsed_response['data'].inspect}"
        parsed_response['data']
      when 'DECLINED', 'VOIDED', 'ERROR'
        raise StandardError, "Payment failed with status: #{status}"
      else
        raise StandardError, "Payment status unknown: #{status}"
      end
    else
      error_message = parsed_response['error'] ? parsed_response['error']['message'] : 'Payment failed'
      raise StandardError, error_message
    end
  rescue StandardError => e
    puts "❌ [CREATE_TRANSACTION] Error al crear la transacción: #{e.message}"
    raise e
  end
end
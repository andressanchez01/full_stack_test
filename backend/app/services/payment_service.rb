require 'net/http'
require 'uri'
require 'json'
require_relative './result' 
require 'digest'
require_relative 'payment_status_service'

class PaymentService
    
    PROVIDER_API_URL = ENV['PROVIDER_API_URL'] || ENV['SANDBOX_API_URL']
    PROVIDER_PUBLIC_KEY = ENV['PROVIDER_PUBLIC_KEY']
    PROVIDER_PRIVATE_KEY = ENV['PROVIDER_PRIVATE_KEY']

    def self.process_payment(transaction, card_data)
        acceptance_token = fetch_acceptance_token

        card_token = create_card_token(card_data)
        return Result.failure("Failed to create card token") if card_token.nil?

        create_transaction(transaction, card_token, acceptance_token)
    end

    def self.fetch_acceptance_token
        url = "#{PROVIDER_API_URL}/merchants/#{PROVIDER_PUBLIC_KEY}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)["data"]
        data.dig("presigned_acceptance","acceptance_token") if data
    rescue StandardError => e
        puts "Error fetching acceptance token: #{e.message}"
        nil
    end

    def self.create_card_token(card_data)
        url = "#{PROVIDER_API_URL}/tokens/cards"
        uri = URI(url)
        headers = {
            "Authorization" => "Bearer #{PROVIDER_PUBLIC_KEY}",
            "Content-Type" => "application/json"
        }
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            request = Net::HTTP::Post.new(uri, headers)
            request.body = card_data.to_json
            http.request(request)
        end
        result = JSON.parse(response.body)
        result.dig("data", "id") if result["data"]
    rescue StandardError => e
        puts "Error creating card token: #{e.message}"
        nil
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
              Result.success(parsed_response['data'])
            when 'DECLINED', 'VOIDED', 'ERROR'
              Result.failure("Payment failed with status: #{status}")
            else
              Result.failure("Payment status unknown: #{status}")
            end
        else
            Result.failure(parsed_response['error'] ? parsed_response['error']['message'] : 'Payment failed')
        end

    rescue => e
        Result.failure("An error occurred while processing the payment: #{e.message}")
    end
    
end
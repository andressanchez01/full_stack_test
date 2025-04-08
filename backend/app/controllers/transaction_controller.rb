require 'json'

class TransactionController
  def self.create(raw_params)
    params = symbolize_keys(raw_params)
    puts "🪵 [CREATE] Params recibidos: #{params.inspect}"

    begin
      transaction = TransactionService.create_transaction(params)
      puts "✅ [CREATE] Transacción creada con éxito: #{transaction.inspect}"
      { status: 'success', data: transaction }
    rescue StandardError => e
      puts "❌ [CREATE] Error al crear la transacción: #{e.message}"
      { status: 'error', message: 'No se pudo crear la transacción', error: e.message }
    end
  end

  def self.update(id, raw_params)
    puts "🪵 [UPDATE] ID recibido: #{id.inspect}, Params recibidos: #{raw_params.inspect}"
    params = symbolize_keys(raw_params)

    unless id && params[:status]
      puts "❌ [UPDATE] Faltan parámetros requeridos: ID: #{id.inspect}, Status: #{params[:status].inspect}"
      return { status: 'error', message: 'Missing required params' }
    end

    begin
      case params[:status]
      when 'COMPLETED'
        if params[:card_data].nil?
          puts "❌ [UPDATE] Faltan datos de la tarjeta para procesar el pago"
          return { status: 'error', message: 'Missing card data for payment processing' }
        end
        puts "🪵 [UPDATE] Procesando pago con datos de tarjeta: #{params[:card_data].inspect}"
        transaction = TransactionService.process_payment(id, params[:card_data])
      when 'FAILED'
        reason = params[:reason] || 'Unknown error'
        puts "🪵 [UPDATE] Marcando transacción como fallida con razón: #{reason.inspect}"
        transaction = TransactionService.mark_transaction_failed(id, reason)
      else
        puts "❌ [UPDATE] Estado de transacción inválido: #{params[:status].inspect}"
        return { status: 'error', message: 'Invalid transaction status' }
      end

      puts "✅ [UPDATE] Transacción actualizada con éxito: #{transaction.inspect}"
      { status: 'success', data: transaction }
    rescue StandardError => e
      puts "❌ [UPDATE] Error al actualizar la transacción: #{e.message}"
      { status: 'error', message: 'No se pudo actualizar la transacción', error: e.message }
    end
  end

  private

  def self.symbolize_keys(hash)
    puts "🪵 [SYMBOLIZE_KEYS] Hash recibido: #{hash.inspect}"
    hash.each_with_object({}) do |(k, v), memo|
      key = k.to_sym rescue k
      memo[key] = v.is_a?(Hash) ? symbolize_keys(v) : v
    end
  end
end
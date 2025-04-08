class TransactionController
  LOGGER = Logger.new(STDOUT)

  def self.create(raw_params)
    params = symbolize_keys(raw_params)
    LOGGER.info("[CREATE] Recibiendo parámetros para crear transacción: #{params.inspect}")

    begin
      transaction = TransactionService.create_transaction(params)
      LOGGER.info("[CREATE] Transacción creada con éxito: ID #{transaction.id}")

      {
        status: 'success',
        data: transaction
      }
    rescue StandardError => e
      LOGGER.error("[CREATE] Error al crear la transacción: #{e.message}")
      {
        status: 'error',
        message: 'No se pudo crear la transacción',
        error: e.message
      }
    end
  end

  def self.update(id, raw_params)
    params = symbolize_keys(raw_params)
    LOGGER.info("[UPDATE] Recibiendo parámetros para actualizar transacción ID=#{id}: #{params.inspect}")

    begin
      case params[:status]
      when 'COMPLETED'
        transaction = TransactionService.process_payment(id, params[:card_data])
        LOGGER.info("[UPDATE] Transacción actualizada con éxito: ID #{transaction.id}")
      when 'FAILED'
        transaction = TransactionService.mark_transaction_failed(id, params[:reason])
        LOGGER.info("[UPDATE] Transacción marcada como fallida: ID #{transaction.id}")
      else
        LOGGER.warn("[UPDATE] Estado de transacción inválido: #{params[:status]}")
        return { status: 'error', message: 'Invalid transaction status' }
      end

      {
        status: 'success',
        data: transaction
      }
    rescue StandardError => e
      LOGGER.error("[UPDATE] Error al actualizar la transacción: #{e.message}")
      {
        status: 'error',
        message: 'No se pudo actualizar la transacción',
        error: e.message
      }
    end
  end

  def self.get_by_id(id)
    LOGGER.info("[GET_BY_ID] Consultando transacción con ID=#{id}")

    transaction = Transaction.find_by(id: id)

    if transaction
      LOGGER.info("[GET_BY_ID] Transacción encontrada: ID=#{transaction.id}")
      {
        status: 'success',
        data: {
          id: transaction.id,
          total_amount: transaction.total_amount,
          status: transaction.status,
          product_id: transaction.product_id,
          customer_id: transaction.customer_id,
          delivery: {
            address: transaction.delivery&.address,
            city: transaction.delivery&.city
          },
          created_at: transaction.created_at,
          updated_at: transaction.updated_at
        }
      }
    else
      LOGGER.info("[GET_BY_ID] Transacción no encontrada: ID=#{id}")
      {
        status: 'error',
        message: 'Transacción no encontrada'
      }
    end
  end

  private

  def self.symbolize_keys(hash)
    LOGGER.debug("[SYMBOLIZE_KEYS] Hash recibido: #{hash.inspect}")
    hash.each_with_object({}) do |(k, v), memo|
      key = k.to_sym rescue k
      memo[key] = v.is_a?(Hash) ? symbolize_keys(v) : v
    end
  end
end
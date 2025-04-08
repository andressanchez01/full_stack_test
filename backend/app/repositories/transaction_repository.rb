require 'logger'

class TransactionRepository
  LOGGER = Logger.new(STDOUT) 

  def self.find_by_id(id)
    begin
      transaction = Transaction.find_by(id: id)
      if transaction
        LOGGER.info("[FIND_BY_ID] Transacción encontrada: ID=#{transaction.id}, Estado=#{transaction.status}")
        transaction
      else
        raise StandardError, "Transacción con ID #{id} no encontrada"
      end
    rescue StandardError => e
      LOGGER.error("[FIND_BY_ID] Error al buscar la transacción: #{e.message}")
      raise e
    end
  end

  def self.create(attrs)
    begin
      transaction = Transaction.new(attrs)
      if transaction.save
        LOGGER.info("[CREATE] Transacción creada: ID=#{transaction.id}, Estado=#{transaction.status}")
        transaction
      else
        error_message = transaction.errors.full_messages.join(', ')
        LOGGER.error("[CREATE] Error al crear la transacción: #{error_message}")
        raise StandardError, error_message
      end
    rescue StandardError => e
      LOGGER.error("[CREATE] Excepción al crear la transacción: #{e.message}")
      raise e
    end
  end

  def self.update_status(id, status, payment_id = nil, reason = nil)
    begin
      transaction = Transaction.find_by(id: id)
      unless transaction
        raise StandardError, "Transacción con ID #{id} no encontrada"
      end

      transaction.status = status
      transaction.payment_id = payment_id if payment_id
      transaction.failure_reason = reason if reason

      if transaction.save
        LOGGER.info("[UPDATE_STATUS] Transacción actualizada: ID=#{transaction.id}, Nuevo estado=#{transaction.status}")
        transaction
      else
        error_message = transaction.errors.full_messages.join(', ')
        LOGGER.error("[UPDATE_STATUS] Error al actualizar la transacción: #{error_message}")
        raise StandardError, error_message
      end
    rescue StandardError => e
      LOGGER.error("[UPDATE_STATUS] Excepción al actualizar la transacción: #{e.message}")
      raise e
    end
  end
end
class TransactionRepository
  def self.find_by_id(id)
    begin
      transaction = Transaction.find_by(id: id)
      if transaction
        puts "✅ [FIND_BY_ID] Transacción encontrada: #{transaction.inspect}"
        transaction
      else
        raise StandardError, "Transaction not found"
      end
    rescue StandardError => e
      puts "❌ [FIND_BY_ID] Error al buscar la transacción: #{e.message}"
      raise e
    end
  end

  def self.create(attrs)
    begin
      transaction = Transaction.new(attrs)
      if transaction.save
        puts "✅ [CREATE] Transacción creada: #{transaction.inspect}"
        transaction
      else
        error_message = transaction.errors.full_messages.join(', ')
        puts "❌ [CREATE] Error al crear la transacción: #{error_message}"
        raise StandardError, error_message
      end
    rescue StandardError => e
      puts "❌ [CREATE] Excepción al crear la transacción: #{e.message}"
      raise e
    end
  end

  def self.update_status(id, status, payment_id = nil, reason = nil)
    begin
      transaction = Transaction.find_by(id: id)
      unless transaction
        raise StandardError, "Transaction not found"
      end

      transaction.status = status
      transaction.payment_id = payment_id if payment_id
      transaction.failure_reason = reason if reason

      if transaction.save
        puts "✅ [UPDATE_STATUS] Transacción actualizada: #{transaction.inspect}"
        transaction
      else
        error_message = transaction.errors.full_messages.join(', ')
        puts "❌ [UPDATE_STATUS] Error al actualizar la transacción: #{error_message}"
        raise StandardError, error_message
      end
    rescue StandardError => e
      puts "❌ [UPDATE_STATUS] Excepción al actualizar la transacción: #{e.message}"
      raise e
    end
  end
end
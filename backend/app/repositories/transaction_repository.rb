class TransactionRepository
  def self.create(transaction_data)
    transaction = Transaction.new(transaction_data)
    
    if transaction.save
      Result.success(transaction)
    else
      Result.failure(transaction.errors.full_messages.join(", "))
    end
  end

  def self.find_by_id(id)
    transaction = Transaction.find_by(id: id)
    return Result.failure("Transaction not found") unless transaction
    Result.success(transaction)
  end

  def self.update_status(id, status, provider_transaction_id = nil, failure_reason = nil)
    result = find_by_id(id)
    return result if result.failure?
    
    transaction = result.value
  
    update_data = { status: status }
    update_data[:provider_transaction_id] = provider_transaction_id if provider_transaction_id
    update_data[:failure_reason] = failure_reason if failure_reason
  
    if transaction.update(update_data)
      Result.success(transaction)
    else
      Result.failure(transaction.errors.full_messages.join(", "))
    end
  end
end
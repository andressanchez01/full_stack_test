class TransactionController
    def self.create(params)
        result = TransactionService.create_transaction(params)
    
        if result.success?
            { status: 'success', data: result.value }
        else
            { status: 'error', message: result.error }
        end
    end
  
    def self.update(id, params)
        return { status: 'error', message: 'Missing required params' } unless id && params[:status]
    
        case params[:status]
        when 'COMPLETED'
            if params[:card_data].nil?
            return { status: 'error', message: 'Missing card data for payment processing' }
            end
            result = TransactionService.process_payment(id, params[:card_data])
    
        when 'FAILED'
            reason = params[:reason] || 'Unknown error'
            result = TransactionService.mark_transaction_failed(id, reason)
    
        else
            return { status: 'error', message: 'Invalid transaction status' }
        end
    
        if result.success?
            { status: 'success', data: result.value }
        else
            { status: 'error', message: result.error }
        end
    end
end
  
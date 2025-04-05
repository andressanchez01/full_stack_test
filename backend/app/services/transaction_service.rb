class TransactionService
    BASE_FEE = 400000 
    DELIVERY_FEE = 900000 
  
    def self.create_transaction(params)
        product_result = ProductRepository.find_by_id(params[:product_id])
        return product_result if product_result.failure?
        
        customer_result = CustomerRepository.create_or_find(params[:customer])
        return customer_result if customer_result.failure?
        
        product = product_result.value
        customer = customer_result.value
        quantity = params[:quantity].to_i
        
        product_total = product.price * quantity
        total_amount = product_total + BASE_FEE + DELIVERY_FEE
        
        transaction_data = {
            customer_id: customer.id,
            product_id: product.id,
            quantity: quantity,
            base_fee: BASE_FEE,
            delivery_fee: DELIVERY_FEE,
            total_amount: total_amount,
            status: 'PENDING'
        }
        
        TransactionRepository.create(transaction_data)
    end
  
    def self.process_payment(transaction_id, card_data)
        transaction_result = TransactionRepository.find_by_id(transaction_id)
        return transaction_result if transaction_result.failure?
        
        transaction = transaction_result.value
        
        payment_result = PaymentService.process_payment(transaction, card_data)
        return payment_result if payment_result.failure?
        
        payment_data = payment_result.value
        
        update_result = TransactionRepository.update_status(
            transaction.id, 
            'COMPLETED', 
            payment_data["id"]
        )
        return update_result if update_result.failure?
        
        stock_result = ProductRepository.update_stock(transaction.product_id, transaction.quantity)
        return stock_result if stock_result.failure?
        
        Result.success(update_result.value)
    end
  
    def self.mark_transaction_failed(transaction_id, reason)
        TransactionRepository.update_status(transaction_id, 'FAILED', nil, reason)
    end
end
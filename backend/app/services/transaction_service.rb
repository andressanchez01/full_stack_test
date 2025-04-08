class TransactionService
    BASE_FEE = 4_000
    DELIVERY_FEE = 9_000
  
    def self.create_transaction(params)
      params = symbolize_keys(params)
      puts "🪵 [CREATE_TRANSACTION] Params recibidos: #{params.inspect}"
  
      begin
        # Buscar el producto
        product = ProductRepository.find_by_id(params[:product_id].to_i)
        puts "✅ [CREATE_TRANSACTION] Producto encontrado: #{product.inspect}"
  
        # Crear o encontrar el cliente
        customer = CustomerRepository.create_or_find(normalize_customer_data(params[:customer]))
        puts "✅ [CREATE_TRANSACTION] Cliente encontrado/creado: #{customer.inspect}"
  
        quantity = params[:quantity].to_i
  
        # Calcular el monto total
        total_amount = calculate_total(product.price, quantity)
        puts "🪵 [CREATE_TRANSACTION] Monto total calculado: #{total_amount}"
  
        # Construir los datos de la transacción
        transaction_data = build_transaction_data(product, customer, quantity, total_amount)
        puts "🪵 [CREATE_TRANSACTION] Datos de la transacción construidos: #{transaction_data.inspect}"
  
        # Crear la transacción y manejar la entrega
        ActiveRecord::Base.transaction do
          transaction = TransactionRepository.create(transaction_data)
          puts "✅ [CREATE_TRANSACTION] Transacción creada: #{transaction.inspect}"
  
          create_delivery_for(transaction, params[:delivery])
          puts "✅ [CREATE_TRANSACTION] Entrega creada para la transacción: #{transaction.id}"
  
          transaction
        end
      rescue StandardError => e
        puts "❌ [CREATE_TRANSACTION] Error al crear la transacción: #{e.message}"
        raise e
      end
    end
  
    def self.process_payment(transaction_id, card_data)
      puts "🪵 [PROCESS_PAYMENT] ID de transacción: #{transaction_id}, Datos de tarjeta: #{card_data.inspect}"
  
      begin
        # Buscar la transacción
        transaction = TransactionRepository.find_by_id(transaction_id)
        puts "✅ [PROCESS_PAYMENT] Transacción encontrada: #{transaction.inspect}"
  
        # Procesar el pago
        payment_data = PaymentService.process_payment(transaction, card_data)
        puts "✅ [PROCESS_PAYMENT] Pago procesado: #{payment_data.inspect}"
  
        # Actualizar el estado de la transacción
        TransactionRepository.update_status(transaction.id, 'COMPLETED', payment_data["id"])
        puts "✅ [PROCESS_PAYMENT] Estado de la transacción actualizado a COMPLETED"
  
        # Actualizar el stock del producto
        ProductRepository.update_stock(transaction.product_id, transaction.quantity)
        puts "✅ [PROCESS_PAYMENT] Stock del producto actualizado"
  
        transaction
      rescue StandardError => e
        puts "❌ [PROCESS_PAYMENT] Error al procesar el pago: #{e.message}"
        raise e
      end
    end
  
    def self.mark_transaction_failed(transaction_id, reason)
      puts "🪵 [MARK_TRANSACTION_FAILED] ID de transacción: #{transaction_id}, Razón: #{reason.inspect}"
  
      begin
        TransactionRepository.update_status(transaction_id, 'FAILED', nil, reason)
        puts "✅ [MARK_TRANSACTION_FAILED] Transacción marcada como fallida"
      rescue StandardError => e
        puts "❌ [MARK_TRANSACTION_FAILED] Error al marcar la transacción como fallida: #{e.message}"
        raise e
      end
    end
  
    # ----------------------------------
    # Métodos privados de utilidad
    # ----------------------------------
  
    def self.symbolize_keys(params)
      puts "🪵 [SYMBOLIZE_KEYS] Params recibidos: #{params.inspect}"
      params.transform_keys(&:to_sym)
    end
  
    def self.calculate_total(price, quantity)
      total = (price * quantity) + BASE_FEE + DELIVERY_FEE
      puts "🪵 [CALCULATE_TOTAL] Precio: #{price}, Cantidad: #{quantity}, Total: #{total}"
      total
    end
  
    def self.build_transaction_data(product, customer, quantity, total)
      data = {
        customer_id: customer.id,
        product_id: product.id,
        quantity: quantity,
        base_fee: BASE_FEE,
        delivery_fee: DELIVERY_FEE,
        total_amount: total,
        status: 'PENDING'
      }
      puts "🪵 [BUILD_TRANSACTION_DATA] Datos construidos: #{data.inspect}"
      data
    end
  
    def self.create_delivery_for(transaction, delivery_params)
      puts "🪵 [CREATE_DELIVERY_FOR] Datos de entrega recibidos: #{delivery_params.inspect}"
  
      begin
        data = normalize_delivery_data(delivery_params)
        delivery = Delivery.new(data.merge(transaction_id: transaction.id, status: 'PENDING'))
  
        if delivery.save
          puts "✅ [CREATE_DELIVERY_FOR] Entrega creada con éxito: #{delivery.inspect}"
        else
          error_message = delivery.errors.full_messages.join(', ')
          puts "❌ [CREATE_DELIVERY_FOR] Error al crear la entrega: #{error_message}"
          raise StandardError, error_message
        end
      rescue StandardError => e
        puts "❌ [CREATE_DELIVERY_FOR] Excepción al crear la entrega: #{e.message}"
        raise e
      end
    end
  
    def self.normalize_delivery_data(data)
      normalized_data = {
        address: data[:address]&.strip,
        city: data[:city]&.strip,
        postal_code: data[:postalCode]&.to_s.strip
      }
      puts "🪵 [NORMALIZE_DELIVERY_DATA] Datos normalizados: #{normalized_data.inspect}"
      normalized_data
    end
  
    def self.normalize_customer_data(data)
      normalized_data = {
        email: data[:email]&.strip&.downcase,
        name: data[:name]&.strip,
        phone: data[:phone]&.gsub(/\s+/, ''),
        address: data[:address]&.strip
      }.compact
      puts "🪵 [NORMALIZE_CUSTOMER_DATA] Datos normalizados: #{normalized_data.inspect}"
      normalized_data
    end
end
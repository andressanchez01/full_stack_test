require 'logger'

class TransactionService
  BASE_FEE = 4_000
  DELIVERY_FEE = 9_000
  IVA = 0.19
  LOGGER = Logger.new(STDOUT) 

  def self.create_transaction(params)
    params = symbolize_keys(params)
    LOGGER.info("[CREATE_TRANSACTION] Params recibidos: #{params.inspect}")
  
    begin
      # Buscar el producto
      product = ProductRepository.find_by_id(params[:product_id].to_i)
      if product.nil?
        LOGGER.error("[CREATE_TRANSACTION] Producto no encontrado: ID=#{params[:product_id]}")
        raise StandardError, "Producto no encontrado"
      end
      LOGGER.info("[CREATE_TRANSACTION] Producto encontrado: ID=#{product.id}, Nombre=#{product.name}")
  
      normalized_customer = normalize_customer_data(params[:customer])
      LOGGER.info("[CREATE_TRANSACTION] Customer normalizado: #{normalized_customer.inspect}")
      customer = CustomerRepository.create_or_find(normalized_customer)
      LOGGER.info("[CREATE_TRANSACTION] Cliente encontrado/creado: ID=#{customer.id}, Email=#{customer.email}")
  
      quantity = params[:quantity].to_i
  
      # Calcular el monto total
      total_amount = calculate_total(product.price, quantity)
      LOGGER.info("[CREATE_TRANSACTION] Monto total calculado: #{total_amount}")
  
      # Construir los datos de la transacción
      transaction_data = build_transaction_data(product, customer, quantity, total_amount)
      LOGGER.debug("[CREATE_TRANSACTION] Datos de la transacción construidos: #{transaction_data.inspect}")
  
      # Crear la transacción y manejar la entrega
      ActiveRecord::Base.transaction do
        transaction = TransactionRepository.create(transaction_data)
        LOGGER.info("[CREATE_TRANSACTION] Transacción creada: ID=#{transaction.id}")
  
        create_delivery_for(transaction, params[:delivery])
        LOGGER.info("[CREATE_TRANSACTION] Entrega creada para la transacción: ID=#{transaction.id}")
  
        transaction
      end
    rescue StandardError => e
      LOGGER.error("[CREATE_TRANSACTION] Error al crear la transacción: #{e.message}")
      raise e
    end
  end

  def self.process_payment(transaction_id, card_data)
    LOGGER.info("[PROCESS_PAYMENT] ID de transacción: #{transaction_id}")
  
    transaction = TransactionRepository.find_by_id(transaction_id)
    if transaction.nil?
      LOGGER.error("[PROCESS_PAYMENT] Transacción con ID #{transaction_id} no encontrada")
      raise StandardError, "Transacción con ID #{transaction_id} no encontrada"
    end
  
    begin
      payment_data = PaymentService.process_payment(transaction, card_data)
      LOGGER.info("[PROCESS_PAYMENT] Pago procesado: ID=#{payment_data['id']}, Estado=#{payment_data['status']}")
  
      TransactionRepository.update_status(transaction.id, 'COMPLETED', payment_data['id'])
      LOGGER.info("[PROCESS_PAYMENT] Estado de la transacción actualizado a COMPLETED")
  
      ProductRepository.update_stock(transaction.product_id, transaction.quantity)
      LOGGER.info("[PROCESS_PAYMENT] Stock del producto actualizado")
  
      transaction
    rescue StandardError => e
      LOGGER.error("[PROCESS_PAYMENT] Error al procesar el pago: #{e.message}")
      raise e
    end
  end

  def self.mark_transaction_failed(transaction_id, reason)
    LOGGER.info("[MARK_TRANSACTION_FAILED] ID de transacción: #{transaction_id}, Razón: #{reason}")

    begin
      TransactionRepository.update_status(transaction_id, 'FAILED', nil, reason)
      LOGGER.info("[MARK_TRANSACTION_FAILED] Transacción marcada como fallida")
    rescue StandardError => e
      LOGGER.error("[MARK_TRANSACTION_FAILED] Error al marcar la transacción como fallida: #{e.message}")
      raise e
    end
  end

  private

  def self.symbolize_keys(params)
    params.transform_keys(&:to_sym)
  end

  def self.calculate_total(price, quantity)
    total = (price * quantity)+ (price * quantity)*IVA + BASE_FEE + DELIVERY_FEE
    LOGGER.debug("[CALCULATE_TOTAL] Precio: #{price}, Cantidad: #{quantity}, Total: #{total}")
    total
  end

  def self.build_transaction_data(product, customer, quantity, total)
    {
      customer_id: customer.id,
      product_id: product.id,
      quantity: quantity,
      base_fee: BASE_FEE,
      delivery_fee: DELIVERY_FEE,
      iva: (product.price * quantity) * IVA,
      total_amount: total,
      status: 'PENDING'
    }
  end

  def self.create_delivery_for(transaction, delivery_params)
    LOGGER.info("[CREATE_DELIVERY_FOR] Creando entrega para la transacción ID=#{transaction.id}")

    begin
      data = normalize_delivery_data(delivery_params)
      delivery = Delivery.new(data.merge(transaction_id: transaction.id, status: 'PENDING'))

      if delivery.save
        LOGGER.info("[CREATE_DELIVERY_FOR] Entrega creada con éxito: ID=#{delivery.id}")
      else
        error_message = delivery.errors.full_messages.join(', ')
        LOGGER.error("[CREATE_DELIVERY_FOR] Error al crear la entrega: #{error_message}")
        raise StandardError, error_message
      end
    rescue StandardError => e
      LOGGER.error("[CREATE_DELIVERY_FOR] Excepción al crear la entrega: #{e.message}")
      raise e
    end
  end

  def self.normalize_delivery_data(data)
    {
      address: data[:address]&.strip,
      city: data[:city]&.strip,
      postal_code: data[:postalCode]&.to_s.strip
    }
  end

  def self.normalize_customer_data(data)
    {
      email: data[:email]&.strip&.downcase,
      name: data[:name]&.strip,
      phone: data[:phone]&.gsub(/\s+/, ''),
      address: data[:address]&.strip
    }.compact
  end
end
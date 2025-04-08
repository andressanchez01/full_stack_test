class CustomerRepository
  def self.create_or_find(customer_params)
    begin
      customer = Customer.find_by(email: customer_params[:email])
      if customer
        puts "✅ [CREATE_OR_FIND] Cliente encontrado: #{customer.inspect}"
        customer
      else
        customer = Customer.create!(customer_params)
        puts "✅ [CREATE_OR_FIND] Cliente creado: #{customer.inspect}"
        customer
      end
    rescue StandardError => e
      puts "❌ [CREATE_OR_FIND] Error al crear o buscar el cliente: #{e.message}"
      raise e
    end
  end
end
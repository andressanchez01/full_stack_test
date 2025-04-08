require 'logger'

class CustomerRepository
  LOGGER = Logger.new(STDOUT) 

  def self.create_or_find(customer_params)
    begin
      customer = Customer.find_by(email: customer_params[:email])
      if customer
        LOGGER.info("[CREATE_OR_FIND] Cliente encontrado: ID=#{customer.id}, Email=#{customer.email}")
        customer
      else
        customer = Customer.create!(customer_params)
        LOGGER.info("[CREATE_OR_FIND] Cliente creado: ID=#{customer.id}, Email=#{customer.email}")
        customer
      end
    rescue StandardError => e
      LOGGER.error("[CREATE_OR_FIND] Error al crear o buscar el cliente: #{e.message}")
      raise e
    end
  end
end
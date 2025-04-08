require 'logger'

class CustomerRepository
  LOGGER = Logger.new(STDOUT)

  def self.create_or_find(customer_params)
    begin
      customer = Customer.find_or_initialize_by(email: customer_params[:email])
      customer.name = customer_params[:name]
      customer.phone = customer_params[:phone]
      customer.address = customer_params[:address]

      customer.save!
      LOGGER.info("[CREATE_OR_FIND] Cliente guardado: ID=#{customer.id}, Email=#{customer.email}")
      customer
    rescue StandardError => e
      LOGGER.error("[CREATE_OR_FIND] Error al crear o actualizar el cliente: #{e.message}")
      raise e
    end
  end
end

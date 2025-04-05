class CustomerRepository
    def self.create_or_find(customer_params)
      customer = Customer.find_by(email: customer_params[:email])
  
      if customer
        Result.success(customer)
      else
        customer = Customer.new(customer_params)
        if customer.save
          Result.success(customer)
        else
          Result.failure(customer.errors.full_messages.join(", "))
        end
      end
    end
end
  
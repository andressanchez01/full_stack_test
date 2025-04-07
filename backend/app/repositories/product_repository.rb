require 'dry/monads'
require 'dry/monads/result'

class ProductRepository
  extend Dry::Monads[:result]

  def self.find_all
    Product.all
  end

  def self.find_by_id(id)
    product = Product.find_by(id: id)
    product ? Success(product) : Failure("Producto no encontrado")
  end

  def self.update_stock(id, quantity)
    result = find_by_id(id)
    return Failure("Product not found") unless result.success?

    product = result.value!
    if product.decrease_stock(quantity)
      Success(product)
    else
      Failure("Insufficient stock")
    end
  end
end
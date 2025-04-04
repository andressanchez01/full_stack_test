class ProductRepository
    def self.find_all
      Product.all
    end
  
    def self.find_by_id(id)
      Product.find_by(id: id)
    end
  
    def self.update_stock(id, quantity)
      product = find_by_id(id)
      return Result.failure("Product not found") unless product
      
      if product.decrease_stock(quantity)
        Result.success(product)
      else
        Result.failure("Insufficient stock")
      end
    end
end
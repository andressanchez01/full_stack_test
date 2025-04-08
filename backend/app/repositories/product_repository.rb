class ProductRepository
  def self.find_all
    Product.all
  end

  def self.find_by_id(id)
    begin
      product = Product.find_by(id: id)
      if product
        puts "✅ [FIND_BY_ID] Producto encontrado: #{product.inspect}"
        product
      else
        raise StandardError, "Producto no encontrado"
      end
    rescue StandardError => e
      puts "❌ [FIND_BY_ID] Error al buscar el producto: #{e.message}"
      raise e
    end
  end

  def self.update_stock(id, quantity)
    begin
      product = find_by_id(id)
      if product.decrease_stock(quantity)
        puts "✅ [UPDATE_STOCK] Stock actualizado para el producto: #{product.inspect}"
        product
      else
        raise StandardError, "Stock insuficiente para el producto con ID #{id}"
      end
    rescue StandardError => e
      puts "❌ [UPDATE_STOCK] Error al actualizar el stock: #{e.message}"
      raise e
    end
  end
end
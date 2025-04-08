require 'logger'

class ProductRepository
  LOGGER = Logger.new(STDOUT) 

  def self.find_all
    Product.all
  end

  def self.find_by_id(id)
    begin
      product = Product.find_by(id: id)
      if product
        LOGGER.info("[FIND_BY_ID] Producto encontrado: ID=#{product.id}, Nombre=#{product.name}")
        product
      else
        raise StandardError, "Producto con ID #{id} no encontrado"
      end
    rescue StandardError => e
      LOGGER.error("[FIND_BY_ID] Error al buscar el producto: #{e.message}")
      raise e
    end
  end

  def self.update_stock(id, quantity)
    begin
      product = find_by_id(id)
      if product.decrease_stock(quantity)
        LOGGER.info("[UPDATE_STOCK] Stock actualizado para el producto: ID=#{product.id}, Nuevo stock=#{product.stock_quantity}")
        product
      else
        raise StandardError, "Stock insuficiente para el producto con ID #{id}"
      end
    rescue StandardError => e
      LOGGER.error("[UPDATE_STOCK] Error al actualizar el stock: #{e.message}")
      raise e
    end
  end
end
require 'logger'

class ProductController
  LOGGER = Logger.new(STDOUT) 

  def self.get_all
    products = ProductRepository.find_all
    serialized_products = products.map { |p| serialize_product(p) }

    LOGGER.info('[GET_ALL] Productos obtenidos exitosamente')
    { status: 'success', data: serialized_products }
  end

  def self.get_by_id(id)
    unless id.to_i.positive?
      LOGGER.warn("[GET_BY_ID] ID inválido: #{id}")
      return { status: 'error', message: 'Invalid product ID' }
    end

    begin
      product = ProductRepository.find_by_id(id)
      LOGGER.info("[GET_BY_ID] Producto encontrado: ID #{id}")
      {
        status: 'success',
        data: serialize_product(product)
      }
    rescue StandardError => e
      LOGGER.error("[GET_BY_ID] Error al obtener el producto: #{e.message}")
      { status: 'error', message: e.message }
    end
  end

  def self.serialize_product(product)
    {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price.to_f,
      stock_quantity: product.stock_quantity
    }
  end
end
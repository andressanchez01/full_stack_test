class ProductController
    def self.get_all
        products = ProductRepository.find_all
        serialized_products = products.map { |p| serialize_product(p) }
      
        { status: 'success', data: serialized_products }
    end
  
    def self.get_by_id(id)
        return { status: 'error', message: 'Invalid product ID' } unless id.to_i.positive?
      
        result = ProductRepository.find_by_id(id)
      
        if result.success?
          product = result.value!
          {
            status: 'success',
            data: serialize_product(product)
          }
        else
          { status: 'error', message: result.failure }
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
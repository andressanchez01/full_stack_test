class ProductController
    def self.get_all
        products = ProductRepository.find_all
        { status: 'success', data: products }
    end
  
    def self.get_by_id(id)
        return { status: 'error', message: 'Invalid product ID' } unless id.to_i.positive?
      
        result = ProductRepository.find_by_id(id)
        result.success? ? { status: 'success', data: result.value } : { status: 'error', message: result.error }
    end
end
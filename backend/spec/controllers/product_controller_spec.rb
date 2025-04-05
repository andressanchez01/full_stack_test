require 'spec_helper'
require_relative '../../app/controllers/product_controller'
require_relative '../../app/repositories/product_repository'
require_relative '../../app/models/product'
require_relative '../../app/services/result'

RSpec.describe ProductController do
  describe '.get_all' do
    it 'returns a list of products with success status' do
      products = [double('Product', id: 1, name: 'Test Product')]
      allow(ProductRepository).to receive(:find_all).and_return(products)

      response = ProductController.get_all

      expect(response[:status]).to eq('success')
      expect(response[:data]).to eq(products)
    end
  end

  describe '.get_by_id' do
    context 'when the product exists' do
      it 'returns the product with success status' do
        product = double('Product', id: 1, name: 'Test Product')
        allow(ProductRepository).to receive(:find_by_id).with(1).and_return(Result.success(product))

        response = ProductController.get_by_id(1)

        expect(response[:status]).to eq('success')
        expect(response[:data]).to eq(product)
      end
    end

    context 'when the product does not exist' do
      it 'returns an error message' do
        allow(ProductRepository).to receive(:find_by_id).with(999).and_return(Result.failure('Product not found'))

        response = ProductController.get_by_id(999)

        expect(response[:status]).to eq('error')
        expect(response[:message]).to eq('Product not found')
      end
    end
  end
end

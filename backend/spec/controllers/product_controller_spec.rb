require 'spec_helper'
require_relative '../../app/controllers/product_controller'
require_relative '../../app/repositories/product_repository'
require_relative '../../app/models/product'

RSpec.describe ProductController do
  describe '.get_all' do
    it 'returns a list of serialized products with success status' do
      products = [
        double('Product', id: 1, name: 'Test Product', description: 'A test product', price: 100.0, stock_quantity: 10)
      ]
      allow(ProductRepository).to receive(:find_all).and_return(products)

      response = ProductController.get_all

      expect(response[:status]).to eq('success')
      expect(response[:data]).to eq([
        {
          id: 1,
          name: 'Test Product',
          description: 'A test product',
          price: 100.0,
          stock_quantity: 10
        }
      ])
    end
  end

  describe '.get_by_id' do
    context 'when the product exists' do
      it 'returns the serialized product with success status' do
        product = double('Product', id: 1, name: 'Test Product', description: 'A test product', price: 100.0, stock_quantity: 10)
        allow(ProductRepository).to receive(:find_by_id).with(1).and_return(product)

        response = ProductController.get_by_id(1)

        expect(response[:status]).to eq('success')
        expect(response[:data]).to eq({
          id: 1,
          name: 'Test Product',
          description: 'A test product',
          price: 100.0,
          stock_quantity: 10
        })
      end
    end

    context 'when the product does not exist' do
      it 'returns an error status with a message' do
        allow(ProductRepository).to receive(:find_by_id).with(1).and_raise(StandardError, 'Producto no encontrado')

        response = ProductController.get_by_id(1)

        expect(response[:status]).to eq('error')
        expect(response[:message]).to eq('Producto no encontrado')
      end
    end

    context 'when the product ID is invalid' do
      it 'returns an error status with a message' do
        response = ProductController.get_by_id(-1)

        expect(response[:status]).to eq('error')
        expect(response[:message]).to eq('Invalid product ID')
      end
    end
  end
end
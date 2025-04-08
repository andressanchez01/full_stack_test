require 'spec_helper'
require_relative '../../app/repositories/product_repository'
require_relative '../../app/models/product'

RSpec.describe ProductRepository, type: :repository do
  let(:logger) { Logger.new(STDOUT) }

  describe '.find_all' do
    it 'returns all products' do
      Product.create!(name: 'Product A', price: 100.0, stock_quantity: 10)
      Product.create!(name: 'Product B', price: 200.0, stock_quantity: 5)

      products = ProductRepository.find_all

      expect(products.count).to eq(2)
      expect(products.map(&:name)).to include('Product A', 'Product B')
    end
  end

  describe '.find_by_id' do
    context 'when the product exists' do
      it 'returns the product and logs the event' do
        product = Product.create!(name: 'Product A', price: 100.0, stock_quantity: 10)
        allow(ProductRepository::LOGGER).to receive(:info) # Simula el logger

        found_product = ProductRepository.find_by_id(product.id)

        expect(found_product).to eq(product)
        expect(ProductRepository::LOGGER).to have_received(:info).with("[FIND_BY_ID] Producto encontrado: ID=#{product.id}, Nombre=#{product.name}")
      end
    end

    context 'when the product does not exist' do
      it 'raises an error and logs the event' do
        allow(ProductRepository::LOGGER).to receive(:error) # Simula el logger

        expect {
          ProductRepository.find_by_id(999)
        }.to raise_error(StandardError, 'Producto con ID 999 no encontrado')

        expect(ProductRepository::LOGGER).to have_received(:error).with("[FIND_BY_ID] Error al buscar el producto: Producto con ID 999 no encontrado")
      end
    end
  end

  describe '.update_stock' do
    context 'when there is enough stock' do
      it 'updates the stock and logs the event' do
        product = Product.create!(name: 'Product A', price: 100.0, stock_quantity: 10)
        allow(ProductRepository::LOGGER).to receive(:info) # Simula el logger

        updated_product = ProductRepository.update_stock(product.id, 5)

        expect(updated_product.stock_quantity).to eq(5)
        expect(ProductRepository::LOGGER).to have_received(:info).with("[UPDATE_STOCK] Stock actualizado para el producto: ID=#{product.id}, Nuevo stock=#{updated_product.stock_quantity}")
      end
    end

    context 'when there is not enough stock' do
      it 'raises an error and logs the event' do
        product = Product.create!(name: 'Product A', price: 100.0, stock_quantity: 3)
        allow(ProductRepository::LOGGER).to receive(:error) # Simula el logger

        expect {
          ProductRepository.update_stock(product.id, 5)
        }.to raise_error(StandardError, 'Stock insuficiente para el producto con ID 1')

        expect(ProductRepository::LOGGER).to have_received(:error).with("[UPDATE_STOCK] Error al actualizar el stock: Stock insuficiente para el producto con ID #{product.id}")
      end
    end
  end
end
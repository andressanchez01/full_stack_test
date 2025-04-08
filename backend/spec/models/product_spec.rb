require 'spec_helper'
require_relative '../../app/models/product'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      product = Product.new(
        name: 'Test Product',
        price: 100.0,
        stock_quantity: 10
      )
      expect(product).to be_valid
    end

    it 'is invalid without a name' do
      product = Product.new(price: 100.0, stock_quantity: 10)
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a price' do
      product = Product.new(name: 'Test Product', stock_quantity: 10)
      expect(product).not_to be_valid
      expect(product.errors[:price]).to include("can't be blank")
    end

    it 'is invalid with a price less than or equal to 0' do
      product = Product.new(name: 'Test Product', price: 0, stock_quantity: 10)
      expect(product).not_to be_valid
      expect(product.errors[:price]).to include('must be greater than 0')
    end

    it 'is invalid without a stock quantity' do
      product = Product.new(name: 'Test Product', price: 100.0)
      expect(product).not_to be_valid
      expect(product.errors[:stock_quantity]).to include("can't be blank")
    end

    it 'is invalid with a stock quantity less than 0' do
      product = Product.new(name: 'Test Product', price: 100.0, stock_quantity: -1)
      expect(product).not_to be_valid
      expect(product.errors[:stock_quantity]).to include('must be greater than or equal to 0')
    end
  end

  describe '#decrease_stock' do
    let(:product) { Product.create!(name: 'Test Product', price: 100.0, stock_quantity: 10) }

    it 'decreases the stock quantity if there is enough stock' do
      expect(product.decrease_stock(5)).to be_truthy
      expect(product.stock_quantity).to eq(5)
    end

    it 'does not decrease the stock quantity if there is not enough stock' do
      expect(product.decrease_stock(15)).to be_falsey
      expect(product.stock_quantity).to eq(10)
    end

    it 'logs an error if an exception occurs' do
      allow(product).to receive(:update).and_raise(StandardError, 'Something went wrong')
      expect(product.decrease_stock(5)).to be_falsey
    end
  end
end
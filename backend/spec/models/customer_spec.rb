require 'spec_helper'
require_relative '../../app/models/customer'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      customer = Customer.new(
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '123456789',
        address: '123 Main St'
      )
      expect(customer).to be_valid
    end

    it 'is invalid without a name' do
      customer = Customer.new(email: 'john.doe@example.com', phone: '123456789', address: '123 Main St')
      expect(customer).not_to be_valid
      expect(customer.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      customer = Customer.new(name: 'John Doe', phone: '123456789', address: '123 Main St')
      expect(customer).not_to be_valid
      expect(customer.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with an improperly formatted email' do
      customer = Customer.new(name: 'John Doe', email: 'invalid_email', phone: '123456789', address: '123 Main St')
      expect(customer).not_to be_valid
      expect(customer.errors[:email]).to include('is invalid')
    end

    it 'is invalid without a phone' do
      customer = Customer.new(name: 'John Doe', email: 'john.doe@example.com', address: '123 Main St')
      expect(customer).not_to be_valid
      expect(customer.errors[:phone]).to include("can't be blank")
    end

    it 'is invalid with a phone number that is too short' do
      customer = Customer.new(name: 'John Doe', email: 'john.doe@example.com', phone: '123', address: '123 Main St')
      expect(customer).not_to be_valid
      expect(customer.errors[:phone]).to include('is too short (minimum is 7 characters)')
    end

    it 'is invalid without an address' do
      customer = Customer.new(name: 'John Doe', email: 'john.doe@example.com', phone: '123456789')
      expect(customer).not_to be_valid
      expect(customer.errors[:address]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      Customer.create!(name: 'Jane Doe', email: 'john.doe@example.com', phone: '987654321', address: '456 Elm St')
      customer = Customer.new(name: 'John Doe', email: 'john.doe@example.com', phone: '123456789', address: '123 Main St')
      expect(customer).not_to be_valid
      expect(customer.errors[:email]).to include('has already been taken')
    end
  end

end
require 'spec_helper'
require_relative '../../app/repositories/customer_repository'
require_relative '../../app/models/customer'

RSpec.describe CustomerRepository, type: :repository do
  let(:logger) { Logger.new(STDOUT) }

  describe '.create_or_find' do
    context 'when the customer exists' do
      it 'returns the existing customer and logs the event' do
        existing_customer = Customer.create!(name: 'John Doe', email: 'john.doe@example.com', phone: '123456789', address: '123 Main St')
        allow(CustomerRepository::LOGGER).to receive(:info) # Simula el logger

        customer = CustomerRepository.create_or_find(
          name: 'John Doe',
          email: 'john.doe@example.com',
          phone: '123456789',
          address: '123 Main St'
        )

        expect(customer).to eq(existing_customer)
        expect(CustomerRepository::LOGGER).to have_received(:info).with("[CREATE_OR_FIND] Cliente encontrado: ID=#{existing_customer.id}, Email=#{existing_customer.email}")
      end
    end

    context 'when the customer does not exist' do
      it 'creates a new customer and logs the event' do
        allow(CustomerRepository::LOGGER).to receive(:info) # Simula el logger

        customer = CustomerRepository.create_or_find(
          name: 'Jane Doe',
          email: 'jane.doe@example.com',
          phone: '987654321',
          address: '456 Elm St'
        )

        expect(customer).to be_persisted
        expect(customer.name).to eq('Jane Doe')
        expect(customer.email).to eq('jane.doe@example.com')
        expect(CustomerRepository::LOGGER).to have_received(:info).with("[CREATE_OR_FIND] Cliente creado: ID=#{customer.id}, Email=#{customer.email}")
      end
    end

    context 'when an error occurs' do
      it 'logs the error and raises an exception' do
        allow(Customer).to receive(:find_by).and_raise(StandardError, 'Database connection error')
        allow(CustomerRepository::LOGGER).to receive(:error) # Simula el logger

        expect {
          CustomerRepository.create_or_find(
            name: 'Error User',
            email: 'error@example.com',
            phone: '000000000',
            address: 'Unknown'
          )
        }.to raise_error(StandardError, 'Database connection error')

        expect(CustomerRepository::LOGGER).to have_received(:error).with("[CREATE_OR_FIND] Error al crear o buscar el cliente: Database connection error")
      end
    end
  end
end
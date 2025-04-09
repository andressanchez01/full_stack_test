require 'spec_helper'
require_relative '../../app/repositories/customer_repository'
require_relative '../../app/models/customer'

RSpec.describe CustomerRepository, type: :repository do
  describe '.create_or_find' do
    let(:valid_customer_params) do
      {
        email: 'test@example.com',
        name: 'John Doe',
        phone: '123456789',
        address: '123 Main St'
      }
    end

    context 'when the customer does not exist' do
      it 'creates a new customer and returns it' do
        expect do
          customer = CustomerRepository.create_or_find(valid_customer_params)
          expect(customer).to be_persisted
          expect(customer.email).to eq(valid_customer_params[:email])
          expect(customer.name).to eq(valid_customer_params[:name])
          expect(customer.phone).to eq(valid_customer_params[:phone])
          expect(customer.address).to eq(valid_customer_params[:address])
        end.to change(Customer, :count).by(1)
      end
    end

    context 'when the customer already exists' do
      let!(:existing_customer) { Customer.create!(valid_customer_params) }

      it 'updates the existing customer and returns it' do
        updated_params = valid_customer_params.merge(name: 'Jane Doe')
        customer = CustomerRepository.create_or_find(updated_params)

        expect(customer).to be_persisted
        expect(customer.id).to eq(existing_customer.id)
        expect(customer.name).to eq('Jane Doe') # Verifica que el nombre se haya actualizado
        expect(customer.phone).to eq(valid_customer_params[:phone])
        expect(customer.address).to eq(valid_customer_params[:address])
      end

      it 'does not create a new customer' do
        expect do
          CustomerRepository.create_or_find(valid_customer_params)
        end.not_to change(Customer, :count)
      end
    end

    context 'when an error occurs' do
      it 'logs the error and raises it' do
        allow(Customer).to receive(:find_or_initialize_by).and_raise(StandardError, 'Test error')

        expect(CustomerRepository::LOGGER).to receive(:error).with(/Error al crear o actualizar el cliente: Test error/)
        expect do
          CustomerRepository.create_or_find(valid_customer_params)
        end.to raise_error(StandardError, 'Test error')
      end
    end
  end
end
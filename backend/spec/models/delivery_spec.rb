require 'spec_helper'
require_relative '../../app/models/delivery'

RSpec.describe Delivery, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      delivery = Delivery.new(
        address: '123 Main St',
        city: 'New York',
        postal_code: '10001',
        status: 'PENDING'
      )
      expect(delivery).to be_valid
    end

    it 'is invalid without an address' do
      delivery = Delivery.new(city: 'New York', postal_code: '10001', status: 'PENDING')
      expect(delivery).not_to be_valid
      expect(delivery.errors[:address]).to include("can't be blank")
    end

    it 'is invalid without a city' do
      delivery = Delivery.new(address: '123 Main St', postal_code: '10001', status: 'PENDING')
      expect(delivery).not_to be_valid
      expect(delivery.errors[:city]).to include("can't be blank")
    end

    it 'is invalid without a postal code' do
      delivery = Delivery.new(address: '123 Main St', city: 'New York', status: 'PENDING')
      expect(delivery).not_to be_valid
      expect(delivery.errors[:postal_code]).to include("can't be blank")
    end

    it 'is invalid without a status' do
      delivery = Delivery.new(address: '123 Main St', city: 'New York', postal_code: '10001')
      expect(delivery).not_to be_valid
      expect(delivery.errors[:status]).to include("can't be blank")
    end

    it 'is invalid with an invalid status' do
      delivery = Delivery.new(address: '123 Main St', city: 'New York', postal_code: '10001', status: 'INVALID')
      expect(delivery).not_to be_valid
      expect(delivery.errors[:status]).to include('is not included in the list')
    end
  end

  describe 'scopes' do
    before do
      @pending_delivery = Delivery.create!(address: '123 Main St', city: 'New York', postal_code: '10001', status: 'PENDING')
      @shipped_delivery = Delivery.create!(address: '456 Elm St', city: 'Los Angeles', postal_code: '90001', status: 'SHIPPED')
      @delivered_delivery = Delivery.create!(address: '789 Oak St', city: 'Chicago', postal_code: '60601', status: 'DELIVERED')
    end

    it 'returns only pending deliveries' do
      expect(Delivery.pending).to include(@pending_delivery)
      expect(Delivery.pending).not_to include(@shipped_delivery, @delivered_delivery)
    end

    it 'returns only shipped deliveries' do
      expect(Delivery.shipped).to include(@shipped_delivery)
      expect(Delivery.shipped).not_to include(@pending_delivery, @delivered_delivery)
    end

    it 'returns only delivered deliveries' do
      expect(Delivery.delivered).to include(@delivered_delivery)
      expect(Delivery.delivered).not_to include(@pending_delivery, @shipped_delivery)
    end
  end

  describe '#mark_as' do
    let(:delivery) { Delivery.create!(address: '123 Main St', city: 'New York', postal_code: '10001', status: 'PENDING') }

    it 'updates the status if the new status is valid' do
      expect(delivery.mark_as('SHIPPED')).to be_truthy
      expect(delivery.status).to eq('SHIPPED')
    end

    it 'does not update the status if the new status is invalid' do
      expect(delivery.mark_as('INVALID')).to be_falsey
      expect(delivery.status).to eq('PENDING')
    end

    it 'logs an error if an exception occurs' do
      allow(delivery).to receive(:update).and_raise(StandardError, 'Something went wrong')
      expect(delivery.mark_as('SHIPPED')).to be_falsey
    end
  end
end
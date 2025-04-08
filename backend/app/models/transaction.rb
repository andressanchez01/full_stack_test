require 'active_record'
require 'securerandom'

class Transaction < ActiveRecord::Base
  belongs_to :customer
  belongs_to :product
  has_one :delivery, foreign_key: 'transaction_id', dependent: :destroy

  validates :transaction_number, presence: true, uniqueness: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validates :base_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :delivery_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }

  validates :status, presence: true, inclusion: { in: ['PENDING', 'COMPLETED', 'FAILED'] }

  validates :payment_id, presence: true, if: -> { status == 'COMPLETED' }
  before_validation :generate_transaction_number, on: :create

  private

  def generate_transaction_number
    self.transaction_number ||= "TXN-#{Time.now.strftime('%Y%m%d%H%M%S')}-#{SecureRandom.hex(2).upcase}"
  end
end
require 'active_record'
require 'securerandom'

class Transaction < ActiveRecord::Base
  belongs_to :customer
  belongs_to :product
  has_one :delivery, dependent: :destroy
  
  enum status: {
    pending: 'PENDING',
    completed: 'COMPLETED',
    failed: 'FAILED'
  }

  validates :transaction_number, presence: true, uniqueness: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: statuses.keys.map(&:upcase) }
  
  before_validation :generate_transaction_number, on: :create
  
  private
  
  def generate_transaction_number
    self.transaction_number ||= "TXN-#{Time.now.strftime('%Y%m%d%H%M%S')}-#{SecureRandom.hex(2).upcase}"
  end
end
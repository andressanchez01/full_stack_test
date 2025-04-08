require 'active_record'
require 'securerandom'
require 'logger'

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
  after_update :log_status_change, if: :saved_change_to_status?
  after_validation :log_validation_errors, if: -> { errors.any? }

  LOGGER = Logger.new(STDOUT) 

  private

  def generate_transaction_number
    self.transaction_number ||= "TXN-#{Time.now.strftime('%Y%m%d%H%M%S')}-#{SecureRandom.hex(2).upcase}"
  rescue StandardError => e
    LOGGER.error("[TRANSACTION] Error al generar el número de transacción: #{e.message}")
    raise e
  end

  def log_status_change
    LOGGER.info("[TRANSACTION] Estado de la transacción actualizado: ID #{id}, Nuevo estado: #{status}")
  end

  def log_validation_errors
    LOGGER.warn("[TRANSACTION] Errores de validación: #{errors.full_messages.join(', ')}")
  end
end
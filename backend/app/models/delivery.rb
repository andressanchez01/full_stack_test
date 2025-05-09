require 'active_record'
require 'logger'

class Delivery < ActiveRecord::Base
  belongs_to :order_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'

  STATUSES = %w[PENDING SHIPPED DELIVERED].freeze

  validates :address, :city, :postal_code, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: 'PENDING') }
  scope :shipped, -> { where(status: 'SHIPPED') }
  scope :delivered, -> { where(status: 'DELIVERED') }

  LOGGER = Logger.new(STDOUT)

  def mark_as(new_status)
    return false unless STATUSES.include?(new_status)

    update(status: new_status)
  rescue StandardError => e
    LOGGER.error("[DELIVERY] Error actualizando el estado de entrega: #{e.message}")
    false
  end
end
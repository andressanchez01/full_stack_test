class Product < ActiveRecord::Base
  has_many :transactions, dependent: :nullify
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  def decrease_stock(quantity)
    return false unless stock_quantity >= quantity

    update(stock_quantity: stock_quantity - quantity)
  rescue StandardError => e
    Rails.logger.error("Error al disminuir el stock: #{e.message}")
    false
  end
end
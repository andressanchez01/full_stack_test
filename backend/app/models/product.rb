class Product < ActiveRecord::Base
    has_many :transactions
    
    validates :name, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
    
    def decrease_stock(quantity)
      if self.stock_quantity >= quantity
        self.update(stock_quantity: self.stock_quantity - quantity)
        true
      else
        false
      end
    end
end
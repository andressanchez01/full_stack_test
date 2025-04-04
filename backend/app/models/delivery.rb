class Delivery < ActiveRecord::Base
    belongs_to :transaction
    
    validates :address, presence: true
    validates :city, presence: true
    validates :postal_code, presence: true
    validates :status, presence: true, inclusion: { in: ['PENDING', 'SHIPPED', 'DELIVERED'] }
end
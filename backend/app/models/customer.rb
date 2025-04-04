class Customer < ActiveRecord::Base
    has_many :transactions
    
    validates :name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone, presence: true
    validates :address, presence: true
end
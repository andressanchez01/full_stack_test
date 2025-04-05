class Customer < ActiveRecord::Base
    has_many :transactions, dependent: :nullify
  
    validates :name, presence: true, length: { maximum: 100 }
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
    validates :phone, presence: true, length: { minimum: 7, maximum: 20 }
    validates :address, presence: true
  
    before_save :normalize_fields
  
    private
  
    def normalize_fields
      self.email = email.strip.downcase if email.present?
      self.phone = phone.gsub(/\s+/, '') if phone.present?
    end
end
  
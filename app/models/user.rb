class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  before_create :set_default_role
  after_create :create_cart

  has_one :cart, dependent: :destroy
  has_many :products, dependent: :destroy  

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self  


    def self.ransackable_associations(auth_object = nil)
      ["cart", "products"]
    end

    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "email", "encrypted_password", "id", "jti", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "updated_at"]
    end

    

   def generate_jwt
    # Assuming you're using `Devise::JWT::Denylist` or similar
    JWT.encode({ id: id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end
        
  ROLES = %w[user admin vendor].freeze

  def jwt_payload
    super
  end

  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role == role_name
    end
  end

  private

  def set_default_role
    self.role ||= 'user'  
  end

  def create_cart
    Cart.create(user: self)
  end
end

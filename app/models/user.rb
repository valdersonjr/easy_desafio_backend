class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # validates 
  validates :email, presence: true
  validates :password, presence: true, on: %i[create update]
  validates :password_confirmation, presence: true, on: %i[create update]
end

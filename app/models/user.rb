class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include WillPaginate::CollectionMethods

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # validates
  validates :email, presence: true
  validates :password, presence: true, on: %i[create update]
  validates :password_confirmation, presence: true, on: %i[create update]
  validates :profile, presence:true

  enum profile: { admin: 0, client: 1 }

  def self.ransackable_attributes(auth_object = nil)
    %w[name email]
  end
end

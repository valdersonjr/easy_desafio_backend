class Load < ApplicationRecord
  include WillPaginate::CollectionMethods

  before_save :uppercase_code

  validates :code, presence: true, uniqueness: true
  validates :delivery_date, presence: true

  has_many :orders

  def self.ransackable_attributes(auth_object = nil)
    %w[code delivery_date]
  end


  def uppercase_code
    self.code = self.code.upcase
  end
end

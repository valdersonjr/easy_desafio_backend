class Load < ApplicationRecord
  include WillPaginate::CollectionMethods

  validates :code, presence: true, uniqueness: true
  validates :delivery_date, presence: true

  has_many :orders

  def self.ransackable_attributes(auth_object = nil)
    %w[code delivery_date]
  end
end

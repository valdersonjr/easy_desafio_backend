class Load < ApplicationRecord
  include WillPaginate::CollectionMethods

  validates :code, presence: true, uniqueness: true
  validates :delivery_date, presence: true
end

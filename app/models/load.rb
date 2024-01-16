class Load < ApplicationRecord
  include WillPaginate::CollectionMethods

  validates :code, presence: true, uniqueness: true
end

class OrderProduct < ApplicationRecord
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :order
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    %w[order_id product_id quantity box]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end
end

class OrderProduct < ApplicationRecord
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :order_id, uniqueness: { scope: :product_id, message: "and product combination already exists in the database" }

  belongs_to :order
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    %w[order_id product_id quantity box]
  end
end

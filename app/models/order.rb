class Order < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :bay, presence: true

  belongs_to :load

  has_many :order_products

  ransacker :has_product, formatter: proc { |value|
    order_ids = OrderProduct.distinct.pluck(:order_id)
    value == 'true' ? order_ids : Order.where.not(id: order_ids).pluck(:id)
  } do |parent|
    parent.table[:id]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[code bay load_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["load", "order_products"]
  end
end

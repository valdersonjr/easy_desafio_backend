class Order < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :bay, presence: true

  belongs_to :load

  has_many :order_products

  def self.ransackable_attributes(auth_object = nil)
    %w[code bay load_id created_at]
  end
end

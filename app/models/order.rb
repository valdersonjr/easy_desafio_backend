class Order < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :bay, presence: true

  belongs_to :load
  has_and_belongs_to_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[code bay load_id]
  end
end

class Order < ApplicationRecord
  belongs_to :load
  has_and_belongs_to_many :products
end

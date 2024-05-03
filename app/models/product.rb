class Product < ApplicationRecord
    include WillPaginate::CollectionMethods

    validates :name, presence: true
    validates :ballast, presence: true
    validates :ballast, numericality: { only_integer: true, greater_than: 0 }

    has_many :order_products
    has_many :sorted_order_products


    def self.ransackable_attributes(auth_object = nil)
        %w[name ballast]
    end

    def self.ransackable_associations(auth_object = nil)
        ["order_products"]
    end
end

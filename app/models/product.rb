class Product < ApplicationRecord
    include WillPaginate::CollectionMethods

    validates :name, presence: true
    validates :ballast, presence: true

    has_many :order_products

    def self.ransackable_attributes(auth_object = nil)
        %w[name ballast]
    end

    def self.ransackable_associations(auth_object = nil)
        ["order_products"]
    end
end

class Product < ApplicationRecord
    include WillPaginate::CollectionMethods

    validates :name, presence: true
    validates :ballast, presence: true

    def self.ransackable_attributes(auth_object = nil)
        %w[name ballast]
    end
end

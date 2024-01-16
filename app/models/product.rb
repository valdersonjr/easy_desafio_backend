class Product < ApplicationRecord
    include WillPaginate::CollectionMethods

    validates :name, presence: true
    validates :ballast, presence: true
end

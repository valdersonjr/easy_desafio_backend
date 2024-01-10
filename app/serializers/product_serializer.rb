class ProductSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :ballast
end

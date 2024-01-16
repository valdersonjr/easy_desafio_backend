class ProductSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :ballast

  def serializable_hash
    data = super
    data.is_a?(Hash) ? data.values.first : data
  end
end

class LoadSerializer
  include JSONAPI::Serializer
  attributes :id, :code, :delivery_date

  def formatted_delivery_date
    object.delivery_date.strftime("%d/%m/%Y") if object.delivery_date
  end

  def serializable_hash
    data = super
    data.is_a?(Hash) ? data.values.first : data
  end
end

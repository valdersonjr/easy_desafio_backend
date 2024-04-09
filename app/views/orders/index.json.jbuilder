json.orders @orders do |order|
  json.id order.id
  json.code order.code
  json.bay order.bay
  json.created_date order.created_at
  json.load_id order.load_id
  json.load_code order.load.code
  json.has_product OrderProduct.where(order_id: order.id).exists?
end

json.pagination_meta @pagination_meta

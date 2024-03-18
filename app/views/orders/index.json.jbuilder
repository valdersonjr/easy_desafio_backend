json.orders @orders do |order|
  json.id order.id
  json.code order.code
  json.bay order.bay
  json.created_date order.created_at
  json.load_id order.load_id
end

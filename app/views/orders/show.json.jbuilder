json.order do
  json.id @order.id
  json.code @order.code
  json.bay @order.bay
  json.load_id @order.load_id
  json.load_code @order.load.code
end

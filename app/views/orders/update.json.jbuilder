json.message "Order updated successfully"
json.order do
  json.code @order.code
  json.bay @order.bay
  json.load_id @order.load_id
end

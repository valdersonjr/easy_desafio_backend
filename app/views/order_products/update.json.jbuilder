json.message "OrderProduct updated successfully"
json.order_product do
  json.order_id @order_product.order_id
  json.product_id @order_product.product_id
  json.quantity @order_product.quantity
  json.box @order_product.box
end

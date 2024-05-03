json.orderProducts @sorted_order_products.includes(:product, :order) do |order_product|
  json.id order_product.id
  json.quantity order_product.quantity
  json.box order_product.box
  json.layer order_product.layer
  json.product do
    @product = order_product.product
    json.id @product.id
    json.name @product.name
    json.ballast @product.ballast
  end
  json.order do
    @order = order_product.order
    json.id @order.id
    json.code @order.code
    json.bay @order.bay
    json.load_id @order.load_id
  end
end

json.pagination_meta @pagination_meta

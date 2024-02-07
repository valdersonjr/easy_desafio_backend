json.products @products do |product|
  json.id product.id
  json.name product.name
  json.ballast product.ballast
  json.created_at product.created_at
end

json.pagination_meta @pagination_meta

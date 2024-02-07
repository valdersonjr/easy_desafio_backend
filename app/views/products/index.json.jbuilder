json.loads @products do |product|
  json.id product.id
  json.name product.name
  json.ballast product.ballast
end

json.pagination_meta @pagination_meta

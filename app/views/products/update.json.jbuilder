json.message "Product updated successfully"
json.product do
  json.id @product.id
  json.name @product.name
  json.ballast @product.ballast
end

json.loads @loads do |load|
  json.id load.id
  json.code load.code
  json.delivery_date load.delivery_date
end

json.pagination_meta @pagination_meta

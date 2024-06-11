require 'benchmark'
require 'activerecord-import'

module PalletizerHelper
  def palletizer(load_code)
    time = Benchmark.realtime do
      find_all_not_sorted_orders_by_load_code(load_code).each do |order|
        palletize(order.order_products)
      end
    end
    puts "------------Runtime: #{time.round(2)} seconds------------"
  end

  private

  def find_load_by_code(load_code)
    Load.find_by(code: load_code)
  end

  def find_all_not_sorted_orders_by_load_code(load_code)
    Order.where(load_id: find_load_by_code(load_code), sorted: false)
  end

  def palletize(order_products)
    layers = 0
    remainder_array = []
    bulk_sorted_order_products_array = []
    order_ids_array = []

    box_type_order_products = order_products.select { |order_product| order_product.box }.sort_by { |order_product| order_product.quantity }.reverse
    not_box_type_order_products = order_products.select { |order_product| !order_product.box }.sort_by { |order_product| order_product.quantity }.reverse


    box_type_order_products.each do |order_product|
      product_layer = order_product.quantity / order_product.product.ballast
      remainder_product = order_product.quantity % order_product.product.ballast

      (1..product_layer).each do |layer|
        bulk_sorted_order_products_array << SortedOrderProduct.new(order_id: order_product.order_id, product_id: order_product.product_id, quantity: order_product.product.ballast, box: order_product.box, layer: layer + layers)
        order_ids_array << order_product.order_id
      end

      layers += product_layer

      if remainder_product > 0
        remainder_array << { remainder: remainder_product, order_id: order_product.order_id, product_id: order_product.product_id, box: order_product.box, ballast: order_product.product.ballast }
      end
    end

    chopper = layers + 1

    remainder_array.each do |remainder_products|
      bulk_sorted_order_products_array << SortedOrderProduct.new(order_id: remainder_products[:order_id], product_id: remainder_products[:product_id], quantity: remainder_products[:remainder], box: remainder_products[:box], layer: chopper)
      order_ids_array << remainder_products[:order_id]
    end

    not_box_type_order_products.each do |order_product|
      bulk_sorted_order_products_array << SortedOrderProduct.new(order_id: order_product.order_id, product_id: order_product.product_id, quantity: order_product.quantity, box: order_product.box, layer: chopper)
      order_ids_array << order_product.order_id
    end


    unique_order_ids_array = order_ids_array.to_set.to_a
    Order.where(id: unique_order_ids_array).update_all(sorted: true)

    SortedOrderProduct.import bulk_sorted_order_products_array
  end
end

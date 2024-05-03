class RemoveUniqueConstraintFromOrderProductsIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :order_products, name: "index_order_products_on_order_id_and_product_id"
    add_index :order_products, ["order_id", "product_id"], name: "index_order_products_on_order_id_and_product_id"
  end
end

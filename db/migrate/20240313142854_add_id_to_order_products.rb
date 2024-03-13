class AddIdToOrderProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :order_products, :id, :primary_key
  end
end

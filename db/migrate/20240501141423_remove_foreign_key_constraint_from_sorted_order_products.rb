class RemoveForeignKeyConstraintFromSortedOrderProducts < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :sorted_order_products, :products
  end
end

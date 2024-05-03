class RemoveForeignKeyConstraintFromOrderProducts < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :order_products, :products
  end
end

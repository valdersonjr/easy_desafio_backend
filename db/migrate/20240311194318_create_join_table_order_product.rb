class CreateJoinTableOrderProduct < ActiveRecord::Migration[7.1]
  def change
    create_table :orders_products, id: false do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :quantity, limit: 255, null: false
      t.boolean :box, null: false, default: false

      t.timestamps
    end

    add_index :orders_products, [:order_id, :product_id], unique: true
  end
end

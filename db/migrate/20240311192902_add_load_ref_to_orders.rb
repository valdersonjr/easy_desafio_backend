class AddLoadRefToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :load, null: false, foreign_key: true
  end
end

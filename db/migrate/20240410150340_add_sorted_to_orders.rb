class AddSortedToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :sorted, :boolean, default: false
  end
end

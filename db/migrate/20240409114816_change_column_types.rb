class ChangeColumnTypes < ActiveRecord::Migration[7.1]
  def change
    change_column :products, :ballast, :integer, using: 'ballast::integer'
    change_column :order_products, :quantity, :integer, using: 'quantity::integer'
  end
end

class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :code, limit: 255, null: false
      t.string :bay, limit: 255, null: false

      t.timestamps
    end
  end
end

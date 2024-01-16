class CreateLoads < ActiveRecord::Migration[7.1]
  def change
    create_table :loads do |t|
      t.string :code, limit: 255, null: false
      t.date :delivery_date

      t.timestamps
    end

    add_index :loads, :code, unique: true
  end
end

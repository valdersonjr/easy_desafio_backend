class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, limit: 255
      t.string :ballast, limit: 255

      t.timestamps
    end
  end
end

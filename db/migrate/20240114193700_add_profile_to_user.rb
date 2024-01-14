class AddProfileToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :profile, :integer, default: 1, null: false

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE users
          ADD CONSTRAINT profile_constraint CHECK (profile IN (0, 1));
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE users
          DROP CONSTRAINT IF EXISTS profile_constraint;
        SQL
      end
    end
  end
end

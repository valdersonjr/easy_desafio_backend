class ChangeDeliveryDateToNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :loads, :delivery_date, false
  end
end

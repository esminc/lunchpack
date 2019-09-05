class ChangeNotNullConstraintForQuarters < ActiveRecord::Migration[5.2]
  def change
    change_column_null :quarters, :period, false
    change_column_null :quarters, :ordinal, false
    change_column_null :quarters, :start_date, false
    change_column_null :quarters, :end_date, false
  end
end

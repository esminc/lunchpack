class AddUniqueIndexToQuarters < ActiveRecord::Migration[5.2]
  def change
    add_index :quarters, [:period, :ordinal], unique: true
  end
end

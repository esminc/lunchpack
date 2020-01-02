class AddUniqueIndexToQuarters < ActiveRecord::Migration[5.2]
  def change
    add_index :quarters, %i(period ordinal), unique: true
  end
end

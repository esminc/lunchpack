class AddIndexToRetiredColumn < ActiveRecord::Migration[5.2]
  def change
    add_index :members, :retired
  end
end

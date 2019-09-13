class AddRetiredToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :retired, :boolean, default: false, null: false
  end
end

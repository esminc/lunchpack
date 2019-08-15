class AddEmailToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :email, :string
  end
end

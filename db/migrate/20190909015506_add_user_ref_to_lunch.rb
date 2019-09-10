class AddUserRefToLunch < ActiveRecord::Migration[5.2]
  def change
    add_reference :lunches, :user, foreign_key: true
  end
end

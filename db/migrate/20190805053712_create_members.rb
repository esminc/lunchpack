class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :hundle_name
      t.string :real_name

      t.timestamps
    end
  end
end

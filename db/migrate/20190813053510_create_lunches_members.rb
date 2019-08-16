class CreateLunchesMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :lunches_members, id: false do |t|
      t.references :lunch, index: true, null: false
      t.references :member, index: true, null: false
    end
  end
end

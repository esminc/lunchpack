class CerateMembersLinches < ActiveRecord::Migration[5.2]
  def change
    create_table :members_lunches, id: false do |t|
      t.references :member, index: true, null: false
      t.references :lunch, index: true, null: false
    end
  end
end

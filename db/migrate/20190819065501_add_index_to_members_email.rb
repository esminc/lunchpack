class AddIndexToMembersEmail < ActiveRecord::Migration[5.2]
  def change
    add_index :members, :email, unique: true
  end
end

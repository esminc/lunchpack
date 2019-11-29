class RenameHundleNameColumnToMembers < ActiveRecord::Migration[6.0]
  def change
    rename_column :members, :hundle_name, :handle_name
  end
end

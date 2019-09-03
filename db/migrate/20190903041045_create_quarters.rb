class CreateQuarters < ActiveRecord::Migration[5.2]
  def change
    create_table :quarters do |t|
      t.integer :period
      t.integer :ordinal
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end

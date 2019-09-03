class AddQuarterRefToLunches < ActiveRecord::Migration[5.2]
  def change
    add_reference :lunches, :quarter, foreign_key: true
  end
end

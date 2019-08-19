class Lunch < ApplicationRecord
  has_and_belongs_to_many :members
  validate :must_have_three_members

  def must_have_three_members
    unless members.size == 3
      errors.add(:members, '3人のメンバーを入力してください')
    end
  end
end

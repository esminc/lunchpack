class Lunch < ApplicationRecord
  has_and_belongs_to_many :members
  validate :must_have_max_members

  MEMBERS_NUMBER = 3

  def must_have_max_members
    unless members.size == MEMBERS_NUMBER
      errors.add(:members, "#{MEMBERS_NUMBER}人のメンバーを入力してください")
    end
  end
end

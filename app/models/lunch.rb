class Lunch < ApplicationRecord
  has_and_belongs_to_many :members
  validate :must_have_benefits_available_count_members

  BENEFITS_AVAILABLE_MEMBERS_COUNT = 3

  def must_have_benefits_available_count_members
    return if members.size == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end
end

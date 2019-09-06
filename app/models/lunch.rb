class Lunch < ApplicationRecord
  belongs_to :quarter
  has_and_belongs_to_many :members
  validate :must_have_benefits_available_count_members

  BENEFITS_AVAILABLE_MEMBERS_COUNT = 3

  def label_with_date_and_member_names
    "#{date} #{members.pluck(:real_name).join(',')}の給付金利用履歴"
  end

  private

  def must_have_benefits_available_count_members
    return if members.size == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end
end

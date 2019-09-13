class Lunch < ApplicationRecord
  belongs_to :created_by,  foreign_key: :user_id, class_name: 'User'
  belongs_to :quarter
  has_and_belongs_to_many :members
  validate :must_have_benefits_available_count_members
  validate :must_has_unique_trio_in_current_quarter

  BENEFITS_AVAILABLE_MEMBERS_COUNT = 3

  def label_with_date_and_member_names
    "#{date} #{members.pluck(:real_name).join(',')}の給付金利用履歴"
  end

  private

  def must_have_benefits_available_count_members
    return if members.size == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end

  # 同じクォーター内で同じメンバーの組み合わせでランチに行ってないことを検証
  def must_has_unique_trio_in_current_quarter
    lunches_in_same_quarter = Lunch.includes(:members).where(quarter: quarter)
    lunches_in_same_quarter.each do |lunch|
      lunched_members = lunch.members & self.members
      if lunched_members.size >= 2
        errors.add(:members, "#{lunched_members.map(&:real_name).join(',')}は#{lunch.date}にランチ済みです")
      end
    end
  end
end

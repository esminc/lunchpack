class Lunch < ApplicationRecord
  belongs_to :created_by,  foreign_key: :user_id, class_name: 'User'
  belongs_to :quarter
  has_and_belongs_to_many :members

  validate :must_go_to_lunch_with_members_who_did_not_go_together_during_same_quarter

  def label_with_date_and_member_names
    "#{date} #{members.pluck(:real_name).join(',')}の給付金利用履歴"
  end

  private

  # 同じクォーター内で同じメンバーの組み合わせでランチに行ってないことを検証
  def must_go_to_lunch_with_members_who_did_not_go_together_during_same_quarter
    lunches_in_same_quarter = Lunch.includes(:members).where(quarter: quarter)
    lunches_in_same_quarter.each do |lunch|
      members_who_went_to_lunch_together = lunch.members & self.members
      if members_who_went_to_lunch_together.size >= 2
        errors.add(:went_to_lunch_with_same_members, "#{members_who_went_to_lunch_together.map(&:real_name).join(',')}は#{lunch.date}にランチ済みです")
      end
    end
  end
end

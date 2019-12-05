class LunchForm
  include ActiveModel::Model

  attr_accessor :date, :members

  validates :date, presence: true
  validate :must_have_benefits_available_count_members
  validate :members_should_exist

  BENEFITS_AVAILABLE_MEMBERS_COUNT = 3

  # 規定人数が満たされていること
  def must_have_benefits_available_count_members
    return if members.count(&:present?) == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members_count, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end

  # 実在する member が指定されていること
  def members_should_exist
    return if Member.where(real_name: members).count == members.count

    errors.add(:members_exist, '存在する名前を入力してください')
  end
end
class LunchForm
  include ActiveModel::Model

  attr_accessor :date, :members

  validates :date, presence: {message: '日付を入力してください'}
  validate :date_must_be_in_the_past, if: -> { date.present? }
  validate :must_have_benefits_available_count_members
  validate :members_should_exist

  BENEFITS_AVAILABLE_MEMBERS_COUNT = 3

  def date_must_be_in_the_past
    return if date.to_date <= Date.current

    errors.add(:date, '今日までの日付を入力してください')
  end

  # 規定人数が満たされていること
  def must_have_benefits_available_count_members
    return if members.count(&:present?) == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end

  # 実在する member が指定されていること
  def members_should_exist
    return if Member.where(real_name: members).count == members.count

    errors.add(:members, '存在する名前を入力してください')
  end
end

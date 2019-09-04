class Lunch < ApplicationRecord
  belongs_to :quarter
  has_and_belongs_to_many :members
  validate :must_have_benefits_available_count_members

  scope :latest, -> { order('date DESC') }

  BENEFITS_AVAILABLE_MEMBERS_COUNT = 3

  before_validation :associate_quarter

  private

  def associate_quarter
    date = self.date
    self.quarter = Quarter.find_or_create_quarter(date)
  end

  def must_have_benefits_available_count_members
    return if members.size == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end
end

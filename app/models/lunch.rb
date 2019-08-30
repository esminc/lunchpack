class Lunch < ApplicationRecord
  has_and_belongs_to_many :members
  validate :must_have_benefits_available_count_members

  scope :in_current_quarter, -> { where(date: current_quarter) }

  BENEFITS_AVAILABLE_MEMBERS_COUNT = 3
  DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH = 7

  def self.current_quarter
    beginning_of_current_quarter = Date.today
      .prev_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH)
      .beginning_of_quarter
      .next_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH)
    beginning_of_next_quarter = beginning_of_current_quarter.next_month(3)
    beginning_of_current_quarter ... beginning_of_next_quarter
  end

  private

  def must_have_benefits_available_count_members
    return if members.size == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end
end

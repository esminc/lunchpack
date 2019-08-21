class Lunch < ApplicationRecord
  has_and_belongs_to_many :members
  validate :must_have_benefits_available_count_members

  scope :in_current_quarter, -> { where(date: current_quarter) }

  BENEFITS_AVAILABLE_MEMBERS_COUNT = 3
  TERM_START_MONTH = 8

  def self.current_quarter
    today = Date.today
    current_term_start_year = today.month >= TERM_START_MONTH ? today.year : today.year - 1
    current_term_start_date = Date.new(current_term_start_year, TERM_START_MONTH)
    3.step(12, 3)
      .map { |n| current_term_start_date.next_month(n - 3) ... current_term_start_date.next_month(n) }
      .detect { |quarter| quarter.cover?(today) }
  end

  private

  def must_have_benefits_available_count_members
    return if members.size == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end
end

class Lunch < ApplicationRecord
  belongs_to :quarter
  has_and_belongs_to_many :members
  validate :must_have_benefits_available_count_members

  scope :latest, -> { order('date DESC') }
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

  before_validation :associate_quarter

  private

  def associate_quarter
    date = self.date
    quarter = Quarter.where('start_date <= ?', date).where('end_date >= ?', date).first
    if quarter.blank?
      quarter = Quarter.create!(
        period: current_period(date),
        ordinal: current_quarter_ordinal(date),
        start_date: start_date_of_quarter(date),
        end_date: end_date_of_quarter(date)
      )
    end
    self.quarter = quarter
  end

  def current_period(date)
    # 例えば2019年は40期なので、西暦から期に変換する差が1979
    date.prev_month(7).year - 1979
  end

  def current_quarter_ordinal(date)
    case date.prev_month(7).beginning_of_quarter.month
    when 1 then 1
    when 4 then 2
    when 7 then 3
    when 10 then 4
    end
  end

  def start_date_of_quarter(date)
    date
      .prev_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH)
      .beginning_of_quarter
      .next_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH)
  end

  def end_date_of_quarter(date)
    start_date_of_quarter(date).next_month(3).yesterday
  end

  def must_have_benefits_available_count_members
    return if members.size == BENEFITS_AVAILABLE_MEMBERS_COUNT

    errors.add(:members, "#{BENEFITS_AVAILABLE_MEMBERS_COUNT}人のメンバーを入力してください")
  end
end

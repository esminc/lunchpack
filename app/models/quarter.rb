class Quarter < ApplicationRecord
  has_many :lunches, dependent: :nullify

  DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH = 7

  class << self
    def current_quarter
      find_or_create_quarter(Date.current)
    end

    def find_or_create_quarter(date)
      quarter = Quarter.where('start_date <= ?', date).find_by('end_date >= ?', date)
      if quarter.blank?
        quarter = Quarter.create!(
          period: current_period(date),
          ordinal: current_quarter_ordinal(date),
          start_date: start_date_of_quarter(date),
          end_date: end_date_of_quarter(date)
        )
      end
      quarter
    end

    private

    def current_period(date)
      # 例えば2019年は40期なので、西暦から期に変換する差が1979
      date.prev_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH).year - 1979
    end

    def current_quarter_ordinal(date)
      convert_from_month_to_quarter_ordinal = {1 => 1, 4 => 2, 7 => 3, 10 => 4}
      month = date.prev_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH).beginning_of_quarter.month
      convert_from_month_to_quarter_ordinal[month]
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
  end

  def cover_today?
    Date.current.between?(start_date, end_date)
  end
end

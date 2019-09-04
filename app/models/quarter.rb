class Quarter < ApplicationRecord
  has_many :lunches

  DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH = 7

  class << self
    def current_quarter(today = Date.today)
      find_or_create_quarter(today)
    end

    def find_or_create_quarter(date)
      quarter = Quarter.where('start_date <= ?', date).where('end_date >= ?', date).first
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

    def current_period(date)
      # 例えば2019年は40期なので、西暦から期に変換する差が1979
      date.prev_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH).year - 1979
    end

    def current_quarter_ordinal(date)
      case date.prev_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH).beginning_of_quarter.month
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
  end
end

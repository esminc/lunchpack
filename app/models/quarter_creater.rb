class QuarterCreater
  DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH = 7

  def initialize(date)
    @date = date
  end

  def create_quarter!
    Quarter.create!(
      period: current_period,
      ordinal: current_quarter_ordinal,
      start_date: start_date_of_quarter,
      end_date: end_date_of_quarter
    )
  end

  private

  # 日付をRailsの beggining_of_quarter が対応する一般的な四期制の日付に変換する
  def shifted_date
    @date.prev_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH)
  end

  # 例えば2019年は40期なので、西暦から1979を引けば期に変換できる
  def current_period
    shifted_date.year - 1979
  end

  def current_quarter_ordinal
    convert_from_month_to_quarter_ordinal = {1 => 1, 4 => 2, 7 => 3, 10 => 4}
    month = shifted_date.beginning_of_quarter.month
    convert_from_month_to_quarter_ordinal[month]
  end

  def start_date_of_quarter
    shifted_date
      .beginning_of_quarter
      .next_month(DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH)
  end

  def end_date_of_quarter
    start_date_of_quarter.next_month(3).yesterday
  end
end

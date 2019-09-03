class LunchesController < ApplicationController
  def index
    @lunches = Lunch.all
  end

  def new
    set_variables_for_new_lunch_view
    @lunch = Lunch.new
  end

  def create
    today = Date.today
    members = Member.where(real_name: params[:lunch][:members])
    quarter = Quarter.where('start_date <= ?', today).where('end_date >= ?',today).first
    quarter = create_quarter(today) if quarter.blank?
    @lunch = Lunch.new(date: today, members: members, quarter: quarter)
    if @lunch.save
      redirect_to root_url, notice: t('dictionary.message.create.complete', record: "#{@lunch.members.pluck(:real_name).join(',')}のランチ")
    else
      set_variables_for_new_lunch_view
      render :new
    end
  end

  private

  def set_variables_for_new_lunch_view
    @members = Member.includes(:projects)
    gon.lunch_trios = Lunch.in_current_quarter.includes(:members).map(&:members)
    gon.login_member = Member.find_by(email: current_user.email)
  end

  def create_quarter(date)
    Quarter.create!(
      period: current_period(date),
      ordinal: current_quarter_ordinal(date),
      start_date: start_date_of_quarter(date),
      end_date: end_date_of_quarter(date)
    )
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

  DIFF_BETWEEN_JANUARY_AND_TERM_START_MOMTH = 7

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

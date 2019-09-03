class LunchesController < ApplicationController
  def index
    @lunches = Lunch.all
    @quarters = Quarter.all
  end

  def new
    set_variables_for_new_lunch_view
    @lunch = Lunch.new
  end

  def create
    today = Date.today
    members = Member.where(real_name: params[:lunch][:members])
    @lunch = Lunch.new(date: today, members: members)
    if @lunch.save
      redirect_to lunches_url, notice: t('dictionary.message.create.complete', record: "#{@lunch.members.pluck(:real_name).join(',')}のランチ")
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
end

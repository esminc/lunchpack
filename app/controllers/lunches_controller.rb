class LunchesController < ApplicationController
  def index
    @quarters = Quarter.includes(lunches: [:lunches_members, :members]).order("quarters.start_date" ,"lunches.date desc")
  end

  def new
    set_variables_for_new_lunch_view
    @lunch = Lunch.new
  end

  def create
    today = Date.today
    members = Member.where(real_name: params[:lunch][:members])
    quarter = Quarter.find_or_create_quarter(today)
    @lunch = quarter.lunches.build(date: today, members: members)
    if @lunch.save
      redirect_to lunches_url, notice: t('dictionary.message.create.complete', record_label: @lunch.record_label)
    else
      set_variables_for_new_lunch_view
      render :new
    end
  end

  def destroy
    @lunch = Lunch.find(params[:id])
    record_label = @lunch.record_label
    @lunch.destroy
    redirect_to lunches_url, notice: t('dictionary.message.destroy.complete', record_label: record_label)
  end

  private

  def set_variables_for_new_lunch_view
    @members = Member.includes(:projects)
    gon.lunch_trios = Quarter.current_quarter.lunches.includes(:members).map(&:members)
    gon.login_member = Member.find_by(email: current_user.email)
  end
end

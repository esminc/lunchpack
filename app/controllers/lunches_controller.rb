class LunchesController < ApplicationController
  def new
    set_variables_for_new_lunch_view
    @lunch = Lunch.new
  end

  def create
    members = Member.where(real_name: params[:lunch][:members])
    @lunch = Lunch.new(date: Date.today, members: members)
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
end

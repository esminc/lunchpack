class LunchesController < ApplicationController
  def new
    @members = Member.includes(:projects)
    @lunch = Lunch.new
    gon.lunches_members = Lunch.includes(:members).map(&:members)
  end

  def create
    members = Member.where(real_name: params[:lunch][:members])
    @lunch = Lunch.new(date: Date.today, members: members)
    if @lunch.save
      redirect_to root_url, notice: 'Lunch was successfully created.'
    else
      render :new
    end
  end
end

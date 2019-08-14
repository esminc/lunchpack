class LunchesController < ApplicationController
  def new
    @members = Member.includes(:projects)
    @lunch = Lunch.new
  end

  def create
    members = lunch_params[:members].map { |name| Member.find_by(real_name: name) }
    @lunch = Lunch.new(date: Date.today, members: members)
    if @lunch.save
      redirect_to root_url, notice: 'Lunch was successfully created.'
    else
      render :new
    end
  end

  private
    def lunch_params
      params.require(:lunch).permit(members: [])
    end
end

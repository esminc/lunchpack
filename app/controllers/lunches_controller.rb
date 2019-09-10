class LunchesController < ApplicationController
  def index
    @quarters = Quarter.includes(lunches: [:lunches_members, :members, :created_by]).order("quarters.start_date" ,"lunches.date desc")
  end

  def new
    set_variables_for_new_lunch_view
    @lunch = Lunch.new
  end

  def create
    today = Date.today
    members = Member.where(real_name: params[:lunch][:members])
    quarter = Quarter.find_or_create_quarter(today)
    @lunch = quarter.lunches.build(date: today, members: members, created_by: current_user)
    if @lunch.save
      redirect_to lunches_url, notice: t('dictionary.message.create.complete', resource_name: @lunch.label_with_date_and_member_names)
    else
      set_variables_for_new_lunch_view
      render :new
    end
  end

  def destroy
    @lunch = Lunch.find(params[:id])

    if @lunch.created_by == current_user
      resource_name = @lunch.label_with_date_and_member_names
      @lunch.destroy
      redirect_to lunches_url, notice: t('dictionary.message.destroy.complete', resource_name: resource_name)
    else
      redirect_to lunches_url, notice: '削除対象となったランチはあなたが作成したものではないので削除できませんでした'
    end
  end

  private

  def set_variables_for_new_lunch_view
    @members = Member.includes(:projects)
    gon.lunch_trios = Quarter.current_quarter.lunches.includes(:members).map(&:members)
    gon.login_member = Member.find_by(email: current_user.email)
  end
end

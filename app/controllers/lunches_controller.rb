class LunchesController < ApplicationController
  def index
    @quarters = Quarter.includes(lunches: [:lunches_members, :members, :created_by]).order("quarters.start_date", "lunches.date desc", "members.created_at")
  end

  def new
    set_variables_for_new_lunch_view
    @lunch_form = LunchForm.new
  end

  def create
    @lunch_form = LunchForm.new(lunch_form_params)

    if @lunch_form.valid?
      members = Member.where(real_name: @lunch_form.members)
      date = @lunch_form.date.to_date
      quarter = Quarter.find_or_create_quarter(date)
      lunch = quarter.lunches.create!(date: date, members: members, created_by: current_user)
      flash[:success] = t('dictionary.message.create.complete', resource_name: lunch.label_with_date_and_member_names)
      redirect_to lunches_url
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
      flash[:danger] = t('dictionary.message.destroy.complete', resource_name: resource_name)
    else
      flash[:warning] = '削除対象となったランチはあなたが作成したものではないので削除できませんでした'
    end
    redirect_to lunches_url
  end

  private

  def lunch_form_params
    params.require(:lunch_form).permit(:date, members: [])
  end

  def set_variables_for_new_lunch_view
    @members = Member.includes(:projects).where(retired: false).order(:created_at)
    gon.lunch_trios = Quarter.current_quarter.lunches.includes(:members).map(&:members)
    gon.login_member = Member.find_by(email: current_user.email)
  end
end

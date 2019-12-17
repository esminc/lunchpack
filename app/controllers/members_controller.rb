class MembersController < ApplicationController
  before_action :set_member, only: [:edit, :update, :destroy]

  def index
    @members = Member.includes(:projects).order(:created_at)
  end

  def new
    @member = Member.new
  end

  def edit
  end

  def create
    @member = Member.new(member_params)

    if @member.save
      flash[:success] = t('dictionary.message.create.complete', resource_name: @member.real_name)
      redirect_to members_url
    else
      render :new
    end
  end

  def update
    if @member.update(member_params)
      flash[:success] = t('dictionary.message.update.complete', resource_name: @member.real_name)
      redirect_to members_url
    else
      render :edit
    end
  end

  def destroy
    @member.destroy
    flash[:danger] = t('dictionary.message.destroy.complete', resource_name: @member.real_name)
    redirect_to members_url
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:handle_name, :real_name, :retired, :email, project_ids: [])
  end
end

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
      redirect_to members_url, notice: t('dictionary.message.create.complete', resource_name: @member.real_name)
    else
      render :new
    end
  end

  def update
    updated_member_params =
      if member_params[:retired] == '1'
        member_params.merge(project_ids: [])
      else
        member_params
      end

    if @member.update(updated_member_params)
      redirect_to members_url, notice: t('dictionary.message.update.complete', resource_name: @member.real_name)
    else
      render :edit
    end
  end

  def destroy
    @member.destroy
    redirect_to members_url, notice: t('dictionary.message.destroy.complete', resource_name: @member.real_name)
  end

  private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(:hundle_name, :real_name, :retired, project_ids: [])
    end
end

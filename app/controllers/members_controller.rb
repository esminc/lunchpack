class MembersController < ApplicationController
  before_action :set_member, only: [:edit, :update, :destroy]

  def index
    @members = Member.includes(:projects)
  end

  def new
    @member = Member.new
  end

  def edit
  end

  def create
    @member = Member.new(member_params)

    if @member.save
      redirect_to members_url, notice: t('dictionary.message.create.complete', record_label: @member.real_name)
    else
      render :new
    end
  end

  def update
    if @member.update(member_params)
      redirect_to members_url, notice: t('dictionary.message.update.complete', record_label: @member.real_name)
    else
      render :edit
    end
  end

  def destroy
    @member.destroy
    redirect_to members_url, notice: t('dictionary.message.destroy.complete', record_label: @member.real_name)
  end

  private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(:hundle_name, :real_name, project_ids: [])
    end
end

class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      flash[:success] = t('dictionary.message.create.complete', resource_name: @project.name)
      redirect_to projects_url
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      flash[:success] = t('dictionary.message.update.complete', resource_name: @project.name)
      redirect_to projects_url
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    flash[:danger] = t('dictionary.message.destroy.complete', resource_name: @project.name)
    redirect_to projects_url
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name)
    end
end

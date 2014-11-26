class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :json

  def index
    authorize! :index, Project
    @projects = current_user.projects
    respond_with(@projects)
  end

  def show
    respond_with(@project)
  end

  def create
    @project = Project.new(project_params)
    @project.save
    respond_with(@project)
  end

  def update
    @project.update(project_params)
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  private
    def set_project
      @project = Project.find(params[:id])
      authorize! :show, @project
    end

    def project_params
      params.require(:project).permit(:title)
    end
end

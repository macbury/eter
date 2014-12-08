class Api::ProjectsController < ApiController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :index, Project
    @projects = Project.by_user(current_user).includes(:users)
    respond_with(:api, @projects)
  end

  def show
    respond_with(:api, @project)
  end

  def create
    @project = Project.new(project_params)
    authorize! :create, @project
    if @project.save
      current_user.assign_master!(@project)
    end
    respond_with(:api,@project)
  end

  def update
    authorize! :update, @project
    @project.update(project_params)
    respond_with(:api, @project)
  end

  def destroy
    authorize! :destroy, @project
    @project.destroy
    respond_with(:api, @project)
  end

  private
    def set_project
      @project = Project.find(params[:id])
      authorize! :show, @project
    end

    def project_params
      params.require(:project).permit(:title, :members_emails)
    end
end

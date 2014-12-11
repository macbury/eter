class Api::ProjectsController < ApiController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :index, Project
    @projects = Project.by_user(current_user).includes(:users)
    respond_with(:api, @projects)
  end

  def new
    @project = Project.new
    respond_with(:api, @project)
  end

  def show
    authorize! :read, @project
    respond_with(:api, @project)
  end

  def create
    @project = Project.new(create_project_params)
    authorize! :create, @project
    if @project.save
      current_user.assign_master!(@project)
    end
    respond_with(:api,@project)
  end

  def edit
    authorize! :edit, @project
    render action: "new"
  end

  def update
    authorize! :update, @project
    @project.update(update_project_params)
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
      authorize! :read, @project
    end

    def create_project_params
      params.require(:project).permit(:title, :members_emails, :point_scale, :start_date, :iteration_start_day, :default_velocity, :iteration_length)
    end

    def update_project_params
      params.require(:project).permit(:title, :point_scale, :start_date, :iteration_start_day, :default_velocity, :iteration_length)
    end
end

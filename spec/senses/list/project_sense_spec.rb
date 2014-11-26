require "rails_helper"
describe ProjectSense do

  it "should propose to create project if project_id is not setted" do
    project_name = "test project name"
    context = sense_context("test project name", :admin)
    sense   = ProjectSense.new(context)
    expect(sense).to have_action(ProjectSense::CREATE_PROJECT_ACTION)
  end

  it "should not propose creation of project if inside another project" do
    project_name = "test project name"
    context = sense_context("test project name", :admin, :project)
    sense   = ProjectSense.new(context)
    expect(sense).not_to have_action(ProjectSense::CREATE_PROJECT_ACTION)
  end

  describe "Sense Context" do
    it "should contain sense in context" do
      context = sense_context("test project name", :admin)
      context.search
      expect(context).to have_action(ProjectSense::CREATE_PROJECT_ACTION)
    end
  end

  it "should propose all projects go to for admin" do
    @projects = FactoryGirl.create_list(:project, 5)
    project_name = @projects.first.title

    context = sense_context(project_name, :admin)
    sense   = ProjectSense.new(context)
    expect(sense).to have_action_with_redirect_to(ProjectSense::GOTO_PROJECT_ACTION, path: :project, params: { project_id: @projects.first.id })
  end

  it "should propose only projects assigned to user" do
    other_projects = FactoryGirl.create_list(:project, 5)
    project_name   = other_projects.first.title.chars.each_slice(2).map(&:join).first
    context        = sense_context(project_name, :user_with_projects)

    user_project   = context.current_user.projects.first

    sense   = ProjectSense.new(context)
    expect(sense).to have_action_with_redirect_to(ProjectSense::GOTO_PROJECT_ACTION, path: :project, params: { project_id: user_project.id })
    expect(sense).not_to have_action_with_redirect_to(ProjectSense::GOTO_PROJECT_ACTION, path: :project, params: { project_id: other_projects.first.id })
  end

  it "should not propose project that i have alredy opened" do
    user            = create(:user_with_projects)
    current_project = user.projects.first
    context         = sense_context(current_project.title, user, current_project)
    sense           = ProjectSense.new(context)
    expect(sense).not_to have_action_with_redirect_to(ProjectSense::GOTO_PROJECT_ACTION, path: :project, params: { project_id: current_project.id })
  end

end

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
end

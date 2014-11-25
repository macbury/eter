require "rails_helper"
describe CreateProjectSense do

  it "should propose to create project if project_id is not setted" do
    project_name = "test project name"
    context = sense_context("test project name", :admin)
    sense   = CreateProjectSense.new(context)

    expect(sense).to be_valid
    expect { sense.to_json }.not_to raise_exception
    expect(sense.to_h).to include(name: "create_project_sense", payload: { name: project_name })
  end

  it "should not propose creation of project if inside another project" do
    project_name = "test project name"
    context = sense_context("test project name", :admin, :project)
    sense   = CreateProjectSense.new(context)

    expect(sense).not_to be_valid
  end

  describe "Sense Context" do
    it "should contain sense in context" do
      context = sense_context("test project name", :admin)
      context.search
      expect(context.results.any? { |sense| sense.class == CreateProjectSense }).to be_truthy
    end
  end
end

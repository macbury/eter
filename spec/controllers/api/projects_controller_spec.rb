require 'rails_helper'

RSpec.describe Api::ProjectsController, type: :controller do

  context "as guest" do
    as_guest

    it "GET index should not be success" do
      get :index, format: :json
      expect(response).not_to be_success
    end

    it "GET new should not be success" do
      get :new
      expect(response).not_to be_success
    end

    it "GET edit should not be success" do
      get :edit, id: -1
      expect(response).not_to be_success
    end

    it "POST create should not be success" do
      post :create
      expect(response).not_to be_success
    end

    it "PUT update should not be success" do
      put :update, id: -1
      expect(response).not_to be_success
    end

    it "delete destroy should not be success" do
      delete :destroy, id: -1
      expect(response).not_to be_success
    end
  end

  context "as admin" do
    as_user(:admin_with_projects)

    describe "GET index" do
      it "should return all projects for me" do
        get :index, format: :json
        expect(assigns(:projects)) =~ Project.all
      end
    end


  end

  context "as user with master permission on projects" do
    as_user(:user_with_projects)

    describe "GET index" do

      it "should only return projects that I`m assigned to" do
        get :index, format: :json
        expect(assigns(:projects)) != Project.all
        expect(assigns(:projects)).not_to be_empty
        expect(assigns(:projects)) =~ controller.current_user.projects
      end
    end

    it "should GET new attributtes for project" do
      get :new, format: :json
      expect(response).to be_success
      expect(response_json).to have_key("project")
      expect(response_json).to include("point_scales" => Project::POINT_SCALES.keys)
      expect(response_json).to include("iteration_length" => Project::ITERATION_LENGTH_RANGE.to_a)
      expect(response_json).to have_key("iteration_start_day")
    end

    it "should GET new attributtes for project" do
      project = controller.current_user.projects.first
      get :edit, id: project.id, format: :json
      expect(response).to be_success
      expect(response_json).to have_key("project")
      expect(response_json).to include("point_scales" => Project::POINT_SCALES.keys)
      expect(response_json).to include("iteration_length" => Project::ITERATION_LENGTH_RANGE.to_a)
      expect(response_json).to have_key("iteration_start_day")
    end

    describe "POST create" do
      it "should create project with valid params" do
        project_attributtes = attributes_for(:project_with_emails_to_invite)
        expect {
          post :create, project: project_attributtes, format: :json
        }.to change { Project.count }.by(1)
        expect(response).to be_success
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
    end
  end

  context "as user with developer access to other projects" do
    let(:master) { FactoryGirl.create(:user_with_projects) }
    let(:master_project) { master.projects.first }
    as_user(:user)
    pending "add other tests"
  end

end

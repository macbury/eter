require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  context "as guest" do
    as_guest

    it "GET index should not be success" do
      get :index, format: :json
      expect(response).not_to be_success
    end

    it "POST create should not be success" do
      post :create
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

  context "as user" do
    as_user(:user_with_projects)

    describe "GET index" do

      it "should only return projects that I`m assigned to" do
        get :index, format: :json
        expect(assigns(:projects)) != Project.all
        expect(assigns(:projects)).not_to be_empty
        expect(assigns(:projects)) =~ controller.current_user.projects
      end
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

end

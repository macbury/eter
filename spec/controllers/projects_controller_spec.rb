require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  context "as guest" do
    as_guest

    it "GET index should not be success" do
      get :index, format: :json
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
        expect(assigns(:projects)) =~ controller.current_user.projects
      end

    end
  end

end

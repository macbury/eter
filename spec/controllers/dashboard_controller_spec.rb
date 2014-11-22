require 'rails_helper'

RSpec.describe DashboardController, :type => :controller do
  context "as guest" do
    as_guest

    describe "GET index" do
      it "should redirect to login for html request" do
        get :index
        expect_to_redirect_to_login
      end
    end
  end


  context "as user" do
    as_user(:user)

    describe "GET index" do
      it "should render dashboard" do
        get :index
        expect(response).to be_success
      end
    end
  end

end

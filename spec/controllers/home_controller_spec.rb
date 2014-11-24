require 'rails_helper'

RSpec.describe HomeController, :type => :controller do

  context "as guest" do
    as_guest
    describe "GET index" do
      it "redirect to sign in path for guest" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "as normal user" do
    as_user(:user)
    describe "GET index" do
      it "redirect to user dashboard" do
        get :index
        expect(response).to be_success
      end
    end
  end

end

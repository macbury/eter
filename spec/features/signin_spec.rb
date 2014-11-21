require "rails_helper"

feature "Signing in" do
  scenario "Signing in with correct credentials" do
    @user = create(:user)
    visit Rails.application.routes.url_helpers.new_user_session_path

    fill_in "Email", with: @user.email
    fill_in "Password", with: "admin1234"
    click_button "Sign in"

    expect(page).to have_text("Signed in successfully.")
  end

  scenario "Signing in with incorrect credentials" do
    visit Rails.application.routes.url_helpers.new_user_session_path
    click_button "Sign in"
    expect(page).to have_text("Invalid email or password.")
  end
end

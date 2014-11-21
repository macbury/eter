require "rails_helper"

feature "Forgot password" do
  scenario "Try to restore password for existing user" do
    @user = create(:user)
    visit Rails.application.routes.url_helpers.new_user_password_path

    fill_in "Email", with: @user.email
    click_button "Send me reset password instructions"

    expect(ActionMailer::Base.deliveries.first.to).to eq(@user.email)

    expect(page).to have_text("You will receive an email with instructions on how to reset your password in a few minutes.")
  end

  scenario "Try to restore password for non existing user" do
    visit Rails.application.routes.url_helpers.new_user_password_path
    click_button "Send me reset password instructions"
    expect(page).to have_text("can't be blank")
  end
end

require "rails_helper"

feature "Dashboard", js: true do

  describe "as admin" do
    as_user(:admin_with_projects)
    scenario "i should see all projects" do
      visit root_path
      Project.all.each do |project|
        expect(page).to have_text(project.title)
      end
    end
  end

  describe "as user" do
    as_user(:user)

    scenario "i should see login and settings option after click sense menu" do
      visit root_path
      find(".sense-open").click

      expect(page).to have_text(I18n.t("sense.logout.label"))
      expect(page).to have_text(I18n.t("sense.settings.label"))
      #save_and_open_screenshot
    end

    scenario "i should be logged out after clicking logout link in sense menu" do
      visit root_path
      find(".sense-open").click

      click_link(I18n.t("sense.logout.label"))
      expect(page.current_path).to eq(new_user_session_path)
    end

    scenario "after typing in sense menu i should see loading message" do
      visit root_path
      find(".sense-input").set("bla bla bla")
      expect(page).to have_text(I18n.t("sense.loading"))
    end

    scenario "after typing in sense menu i should see error message for any internal error on server side" do
      allow_any_instance_of(SenseController).to receive(:create).and_return { raise Exception.new }
      visit root_path
      find(".sense-input").set("bla bla bla")

      expect(page).to have_text(I18n.t("flashes.internal_server_error"))
    end
  end

end

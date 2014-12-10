require "rails_helper"

feature "Dashboard", js: true do

  describe "as user with projects" do
    as_user(:user_with_projects)

    scenario "i should see projects in dashboard" do
      visit root_path
      projects = Project.by_user(current_user)

      expect(page).not_to have_text(I18n.t("projects.empty"))
      click_on("Active projects")

      projects.each do |project|
        expect(page).to have_text(project.title.upcase)
      end
    end
  end

  describe "as user without projects" do
    as_user(:user)

    scenario "i should see information about no projects assigned to me" do
      visit root_path
      expect(page).to have_text(I18n.t("projects.empty"))
    end

    scenario "i should see login and settings option after click sense menu" do
      visit root_path
      open_sense_menu

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
      allow_any_instance_of(Api::SenseController).to receive(:create).and_return { raise Exception.new }
      visit root_path
      find(".sense-input").set("bla bla bla")

      expect(page).to have_text(I18n.t("flashes.internal_server_error"))
    end
  end

end

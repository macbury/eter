require "rails_helper"

feature "Sense menu", js: true do
  let(:sense_input_css_id) { ".sense-input" }
  describe "as user with projects" do
    as_user(:user_with_projects)
    let(:project_query) { "project" }

    scenario "after typing anything i should see selected first option" do
      visit root_path
      find(sense_input_css_id).set(project_query)
      expect(page).to have_css(".result-suggestions li:first-child.selected")

    end

    scenario "if i have options in sense menu i should be able to move between options using keyboard keys" do
      visit root_path
      find(sense_input_css_id).set(project_query)

      expect(page).to have_selected_sense_suggestion_at_index(1)
      page_trigger_key_on(sense_input_css_id, BrowserMacro::BROWSER_KEY_DOWN)
      expect(page).to have_selected_sense_suggestion_at_index(2)

      page_trigger_key_on(sense_input_css_id, BrowserMacro::BROWSER_KEY_UP)
      expect(page).to have_selected_sense_suggestion_at_index(1)

      20.times { page_trigger_key_on(sense_input_css_id, BrowserMacro::BROWSER_KEY_UP) }
      expect(page).to have_selected_sense_suggestion_at_index(1)

      5.times { page_trigger_key_on(sense_input_css_id, BrowserMacro::BROWSER_KEY_DOWN) }
      expect(page).to have_selected_sense_suggestion_at_index(6)

      20.times { page_trigger_key_on(sense_input_css_id, BrowserMacro::BROWSER_KEY_DOWN) }
      expect(page).to have_selected_sense_suggestion_at_index(6)
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
      find(sense_input_css_id).set("bla bla bla")
      expect(page).to have_text(I18n.t("sense.loading"))
    end
    scenario "after typing in sense menu i should see error message for any internal error on server side" do
      allow_any_instance_of(SenseController).to receive(:create).and_return { raise Exception.new }
      visit root_path
      find(sense_input_css_id).set("bla bla bla")

      expect(page).to have_text(I18n.t("flashes.internal_server_error"))
    end
  end

end

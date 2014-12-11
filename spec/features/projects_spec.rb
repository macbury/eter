require "rails_helper"

feature "Projects", js: true do

  describe "as user without projects" do
    as_user(:user)

    it "should allow to create new project using sense menu" do
      project_attributtes = attributes_for(:project_with_emails_to_invite)
      visit root_path
      find(".sense-input").set(project_attributtes[:title])
      expect(page).to have_selected_sense_suggestion_at_index(1)
      click_link(I18n.t("senses.create_project_action.label"))

      fill_in("Start date", with: "2014-05-11")
      fill_in("Default velocity", with: 22)
      fill_in("Members", with: project_attributtes[:members_emails])
      select("Power of two (0,1,2,4,8)")
      select("Sunday")

      expect(find("input#project_title").value).to eq(project_attributtes[:title])

      find("button.btn-success").trigger('click')
      expect(page).to have_text(project_attributtes[:title])
      expect(page.current_url).to match(/#\/projects\/[0-9]+/i)
    end

    it "should show errors in sense menu" do
      project_attributtes = attributes_for(:project_with_emails_to_invite)
      visit root_path
      find(".sense-input").set(project_attributtes[:title])
      expect(page).to have_selected_sense_suggestion_at_index(1)
      click_link(I18n.t("senses.create_project_action.label"))

      fill_in("Title", with: "")
      find("button.btn-success").trigger('click')
      expect(page).to have_text("can't be blank")
      expect(page.current_url).to match(/#\/projects$/i)
    end
  end

  describe "as user without developer permission for project he should see unauthorized access for" do
    let(:master) { FactoryGirl.create(:user_with_projects) }
    let(:master_project) { master.projects.first }
    as_user(:user)

    it "Show project #/projects/:id" do
      visit_hash "#/projects/#{master_project.id}"
      expect(page).to have_text("You are not authorized to access this page")
    end

    it "Edit project #/projects/:id/edit" do
      visit_hash "#/projects/#{master_project.id}/edit"
      expect(page).to have_text("You are not authorized to access this page")
    end
  end

  describe "as user with developer permission for project" do
    as_user(:user)
    let(:master_project) do
      project = FactoryGirl.create(:user_with_projects).projects.first
      current_user.assign_developer!(project)
      project
    end

    it "should show project #/projects/:id" do
      visit_hash "#/projects/#{master_project.id}"
      expect(page).to have_text(master_project.title)
      open_sense_menu
      expect(page).not_to have_text(I18n.t("sense.project_settings.label"))
    end

    it "should not allow project editing" do
      visit_hash "#/projects/#{master_project.id}/edit"
      expect(page).to have_text("You are not authorized to access this page")
    end
  end

  describe "as user with master permission for project" do
    as_user(:user_with_projects)
    let(:master_project) { current_user.projects.first }

    it "should show edit project button" do
      visit_hash "#/projects/#{master_project.id}"
      expect(page).to have_text(master_project.title)
      open_sense_menu
      expect(page).to have_text(I18n.t("sense.project_settings.label"))
    end

    it "should allow project editing with valid data" do
      visit_hash "#/projects/#{master_project.id}/edit"

      fill_in("Title", with: "New title")
      fill_in("Start date", with: "1990-05-11")
      fill_in("Default velocity", with: 11)
      select("Power of two (0,1,2,4,8)")
      select("Sunday")
      select("2 weeks")

      find("button.btn-success").trigger('click')

      expect(page).to have_text("Changes have been saved")

      master_project.reload
      expect(master_project.default_velocity).to eq(11)
      expect(master_project.title).to eq("New title")
      expect(master_project.point_scale).to eq("powers_of_two")
      expect(master_project.iteration_start_day).to eq(0)
      expect(master_project.iteration_length).to eq(2)
    end

    it "should allow project editing with invalid data" do
      visit_hash "#/projects/#{master_project.id}/edit"
      fill_in("Title", with: "")
      fill_in("Start date", with: "")
      fill_in("Default velocity", with: "")

      find("button.btn-success").trigger('click')
      expect(page).to have_text("can't be blank")

      fill_in("Title", with: "New title")
      fill_in("Start date", with: "1990-05-11")
      fill_in("Default velocity", with: 11)
      find("button.btn-success").trigger('click')
      expect(page).not_to have_text("can't be blank")
    end
  end
end

require "rails_helper"

feature "Projects", js: true do
  as_user(:user)

  it "should allow to create new project using sense menu" do
    project_attributtes = attributes_for(:project_with_emails_to_invite)
    visit root_path
    find(".sense-input").set(project_attributtes[:title])
    expect(page).to have_selected_sense_suggestion_at_index(1)
    click_link(I18n.t("senses.create_project_action.label"))

    title_input   = find("input#project_title")
    members_input = find("input.token-input")
    expect(title_input.value).to eq(project_attributtes[:title])

    members_input.set(project_attributtes[:members_emails])

    #save_and_open_screenshot
  end

end

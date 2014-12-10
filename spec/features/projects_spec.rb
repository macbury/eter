require "rails_helper"

feature "Projects", js: true do
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

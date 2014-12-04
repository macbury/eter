require 'rails_helper'

RSpec.describe Project, :type => :model do
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }

  it "should assign users passed by members_emails attribute" do
    project = build(:project)
    users   = create_list(:user, 10)
    project.members_emails = users.map(&:full_info).join(", ")
    project.save

    users.each do |user|
      expect(project.members).to include(user)
      expect(user).to have_role(Project::ROLE_DEVELOPER, project)
    end
  end

  it "should send invite email for non existing users" do
    project = build(:project)
    user    = attributes_for(:user)
    project.members_emails = user[:email]
    project.save

    expect(project.members.map(&:email)).to include(user[:email])
  end
end

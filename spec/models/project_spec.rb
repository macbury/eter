require 'rails_helper'

RSpec.describe Project, :type => :model do
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }

  it "should generate unique slug id after creation" do
    project = FactoryGirl.create(:project)
    expect(project.slug).to be_present
  end
end

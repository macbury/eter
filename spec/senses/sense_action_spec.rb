require "rails_helper"

describe SenseAction, type: :model do
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:payload) }
  it { should validate_presence_of(:priority) }

  it "should add each extra into payload" do
    action = SenseAction.new
    action.put_extra(:project_id, 1)
    expect(action.to_h).to include( payload: { project_id: 1 } )
  end
end

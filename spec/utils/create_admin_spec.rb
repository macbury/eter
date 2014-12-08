require 'rails_helper'
require "create_admin"
RSpec.describe CreateAdmin do
  it "should create admin user with email from figaro config and default password admin1234" do
    expect {
      @create_admin = CreateAdmin.new
    }.to change(User, :count).by(1)

    expect(@create_admin.user).not_to be_new_record
    expect(@create_admin.user.email).to eq(Figaro.env.admin_email)
    expect(@create_admin.user).to be_admin
  end
end

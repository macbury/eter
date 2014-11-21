module DeviseMacros

  def login_user(factory_name)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user                           = FactoryGirl.create(factory_name)
      sign_in user
    end
  end

end

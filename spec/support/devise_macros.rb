module DeviseMacros

  def as_user(factory_name)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user                           = FactoryGirl.create(factory_name)
      sign_in user
    end
  end

  def as_guest
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_out :user
    end
  end

end

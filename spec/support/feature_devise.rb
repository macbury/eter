module FeatureDevise

  def as_user(factory_name)
    before(:each) do
      @user                          = FactoryGirl.create(factory_name)
      login_as(@user, scope: :user, run_callbacks: false)
    end
  end

  def as_guest
    before(:each) do
      logout(:user)
    end
  end

end

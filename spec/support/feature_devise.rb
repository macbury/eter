module FeatureDevise

  def as_user(factory_name)
    let(:current_user) {  FactoryGirl.create(factory_name) }
    before(:each) do
      login_as(current_user, scope: :user, run_callbacks: false)
    end
  end

  def as_guest
    before(:each) do
      logout(:user)
    end
  end

end

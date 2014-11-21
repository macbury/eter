class CreateAdmin

  def initialize
    @user           = User.new
    @user.email     = Figaro.env.admin_email
    @user.password  = @user.password_confirmation = "admin1234"
    @user.add_role(:admin)
    @user.save!
  end

  def user
    @user
  end

end

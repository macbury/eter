class CreateAdmin

  def initialize
    @user           = User.new
    @user.first_name = "Super"
    @user.last_name = "Admin"
    @user.email     = Figaro.env.admin_email
    @user.password  = @user.password_confirmation = "admin1234"
    @user.admin     = true
    @user.save!
  end

  def user
    @user
  end

end

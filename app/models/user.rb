class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  rolify

  def projects
    Project.with_role([:master, :developer], self)
  end
end

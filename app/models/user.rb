class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  rolify

  def projects
    if has_role?(:admin)
      Project.all
    else
      Project.with_role([:master, :developer], self)
    end
  end

  def project_ids
    projects.pluck(:id)
  end
end

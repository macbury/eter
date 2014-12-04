class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  rolify

  validates :first_name, :last_name, presence: true, on: :update

  scope :by_query, -> (query) { where("last_name LIKE :query OR first_name LIKE :query OR email LIKE :query", query: query+"%") }

  def full_name
    [first_name, last_name].join(" ")
  end

  def full_info
    "#{full_name} <#{email}>"
  end

  def admin?
    has_role?(:admin)
  end

  def projects
    Project.by_user(self)
  end

  def project_ids
    projects.pluck(:id)
  end
end

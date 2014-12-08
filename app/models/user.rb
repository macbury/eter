class User < ActiveRecord::Base
  EMAIL_REGEXP   = /([a-z0-9_\-\.]+@[a-z0-9_\-\.]+\.[a-z0-9_\-\.]+)/i
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, presence: true, on: :update

  has_many :members, dependent: :destroy
  has_many :projects, through: :members, source: :source, source_type: "Project"

  scope :by_query, -> (query) { where("last_name LIKE :query OR first_name LIKE :query OR email LIKE :query", query: query+"%") }
  scope :by_email, -> (email) { where(email: email) }

  def full_name
    [first_name, last_name].join(" ")
  end

  def full_info
    "#{full_name} <#{email}>"
  end

  def initials
    [first_name[0], last_name[0]].join("")
  end

  def add_role(role, resource)
    member      = members.find_or_initialize_by(source_type: resource.class.to_s, source_id: resource.id)
    member.role = role
    member.save!
    member
  end

  def has_role?(roles, resource)
    members.by_source(resource).by_roles(roles).count > 0
  end

  def assign_master!(resource)
    add_role Member::ROLE_MASTER, resource
  end

  def assign_developer!(resource)
    add_role Member::ROLE_DEVELOPER, resource
  end

  def pending_invitation?
    invitation_token.present?
  end

  def admin?
    admin
  end

end

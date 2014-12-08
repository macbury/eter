class Member < ActiveRecord::Base
  ROLE_MASTER    = :master
  ROLE_DEVELOPER = :developer
  ROLE_ADMIN     = :admin
  ROLES          = [ROLE_MASTER, ROLE_DEVELOPER, ROLE_DEVELOPER]

  belongs_to :user, touch: true
  belongs_to :source, touch: true, polymorphic: true

  validates :user, presence: true
  validates :source, presence: true
  validates :user_id, uniqueness: { scope: [:source_type, :source_id], message: "already exists in source" }
  validates :role, presence: true, inclusion: { in: ROLES }

  scope :by_source, -> (source) { where("source_type = :source_type AND source_id = :source_id", source_type: source.class.to_s, source_id: source.id) }
  scope :by_roles,  -> (roles)  {
    roles = [roles] if roles.class != Array
    where("role IN (:role_names)", role_names: roles)
  }
end

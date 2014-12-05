class Project < ActiveRecord::Base
  resourcify
  validates :title, presence: true, uniqueness: true

  ROLE_MASTER    = :master
  ROLE_DEVELOPER = :developer
  EMAIL_REGEXP   = /([a-z0-9_\-\.]+@[a-z0-9_\-\.]+\.[a-z0-9_\-\.]+)/i

  attr_accessor :members_emails

  scope :by_title,        -> (title) { where("title LIKE :title", title: title+"%") }
  scope :except_project,  -> (project) { where("projects.id != :project_id", project_id: project.id) if project }
  scope :by_user,         -> (user) { user.admin? ? all : with_role([ROLE_MASTER, ROLE_DEVELOPER], user) }

  after_create :assign_members!

  def members
    user_ids = roles.map(&:user_ids).flatten
    @members ||= User.find(user_ids)
  end

  def members_emails
    unless @members_emails
      @members_emails = members.map(&:full_info).join(", ")
    end
    @members_emails
  end

  def members_emails=(nme)
    @members_emails = nme.split(", ")
  end

  def add_master!(user)
    user.add_role ROLE_MASTER, self
  end

  def add_developer!(user)
    user.add_role ROLE_DEVELOPER, self
  end

  protected

    def assign_members!
      if @members_emails
        emails = @members_emails.map do |email|
          email.strip!
          if email.match(EMAIL_REGEXP)
            $1
          else
            nil
          end
        end.compact

        emails.each do |email|
          user = User.invite!(email: email)
          add_developer!(user)
        end
      end
    end

end

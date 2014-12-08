class Project < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true

  has_many :members, dependent: :destroy, as: :source
  has_many :users, through: :members

  attr_accessor :members_emails

  scope :by_title,        -> (title) { where("title LIKE :title", title: title+"%") }
  scope :except_project,  -> (project) { where("projects.id != :project_id", project_id: project.id) if project }
  scope :by_user,         -> (user) { user.admin? ? all : where("members.user_id = :user_id", user_id: user.id).joins(:members) }

  before_create :generate_colors!
  after_create :assign_members!

  def members_emails
    unless @members_emails
      @members_emails = users.map(&:full_info).join(", ")
    end
    @members_emails
  end

  def members_emails=(nme)
    @members_emails = nme.split(", ")
  end

  def generate_colors!
    background_generator = ColorGenerator.new saturation: 0.2, value: 0.2, seed: self.title.sum
    self.color_hex = background_generator.create_hex
  end

  protected

    def assign_members!
      if @members_emails
        emails = @members_emails.map do |email|
          email.strip!
          if email.match(User::EMAIL_REGEXP)
            $1
          else
            nil
          end
        end.compact

        emails.each do |email|
          user = User.invite!(email: email)
          user.assign_developer!(self)
        end
      end
    end

end

class Project < ActiveRecord::Base
  POINT_SCALES = {
    'fibonacci' => [0,1,2,3,5,8],
    'powers_of_two' => [0,1,2,4,8],
    'linear' => [0,1,2,3,4,5],
  }

  ITERATION_LENGTH_RANGE = (1..4)

  has_many :members, dependent: :destroy, as: :source
  has_many :users, through: :members
  has_many :stories, dependent: :destroy

  attr_accessor :members_emails

  validates :title, presence: true, uniqueness: true

  validates_numericality_of :iteration_length,
    greater_than_or_equal_to: ITERATION_LENGTH_RANGE.min,
    less_than_or_equal_to:    ITERATION_LENGTH_RANGE.max,
    only_integer:             true,
    message:                  I18n.t("activerecord.errors.project_week_error")
  validates_inclusion_of :point_scale,
    in:       POINT_SCALES.keys,
    message:  I18n.t("activerecord.errors.project_point_scale")
  validates_numericality_of :iteration_start_day,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to:    6,
    only_integer:             true,
    message:                  I18n.t("activerecord.errors.iteration_start_day")
  validates_numericality_of :default_velocity,
    greater_than: 0,
    only_integer: true

  validates :start_date, presence: true

  scope :by_title,        -> (title) { where("title LIKE :title", title: title+"%") }
  scope :except_project,  -> (project) { where("projects.id != :project_id", project_id: project.id) if project }
  scope :by_user,         -> (user) { user.admin? ? all : where("members.user_id = :user_id", user_id: user.id).joins(:members) }

  before_create :generate_colors!
  after_create :assign_members!

  def point_values
    POINT_SCALES[point_scale]
  end

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

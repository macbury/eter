require "validators/belongs_to_project_validator"
class Story < ActiveRecord::Base
  include StoryStateConcern
  STORY_TYPES = [ 'feature', 'chore', 'bug', 'release' ]
  belongs_to :project, touch: true

  validates :story_type, inclusion: STORY_TYPES, presence: true
  validates :title, presence: true, uniqueness: true
  validates :project, presence: true

  belongs_to :requested_by, class_name: 'User'
  validates :requested_by_id, belongs_to_project: true

  scope :done, -> { where(:state => :accepted) }
  scope :in_progress, -> { where(:state => [:started, :finished, :delivered]) }
  scope :backlog, -> { where(:state => :unstarted) }
  scope :chilly_bin, -> { where(:state => :unscheduled) }
end

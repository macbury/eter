class Project < ActiveRecord::Base
  resourcify
  validates :title, presence: true, uniqueness: true

  scope :by_title, -> (title) { where("title LIKE :title", title: title+"%") }
  scope :except_project, -> (project) { where("projects.id != :project_id", project_id: project.id) if project }
end

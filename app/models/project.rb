class Project < ActiveRecord::Base
  resourcify
  validates :title, presence: true, uniqueness: true

  scope :by_title, -> (title) { where("title LIKE :title", title: title+"%") }
end

class Project < ActiveRecord::Base
  resourcify
  validates :title, presence: true, uniqueness: true

end

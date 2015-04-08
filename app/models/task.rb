class Task < ActiveRecord::Base

  belongs_to :project
  has_many :tasks

  validates :description, presence: true

end

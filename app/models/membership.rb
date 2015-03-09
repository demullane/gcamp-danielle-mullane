class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :user_id, :role, presence: true
  validates_uniqueness_of :user_id, :scope => :project_id, message: "has already been added to this project."

end

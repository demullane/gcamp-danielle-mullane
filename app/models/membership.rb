class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :user_id, :role, presence: true
  validates_uniqueness_of :user_id, :scope => :project_id, message: "has already been added to this project."
  # validate :last_owner

  # def last_owner
  #   project = self.project
  #   if project.memberships.find_all{|membership| membership.role == "Owner"}.count == 1
  #     unless self.role == "Owner"
  #       errors[:base] << "Projects must have at least one owner."
  #       #redirect_to project_memberships_path(project)
  #     end
  #   end
  # end

end

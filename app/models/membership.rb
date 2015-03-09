class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :user_id, :role, presence: true

  def member_name
    "#{user_id.first_name}"
  end
end

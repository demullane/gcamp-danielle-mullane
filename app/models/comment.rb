class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :task

  validates :description, presence: true

  def user_exist_check
    if !(User.exists?(self.user_id))
      self.user_id = nil
      self.save
    end
  end

end

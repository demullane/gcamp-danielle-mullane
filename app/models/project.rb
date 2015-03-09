class Project < ActiveRecord::Base

  has_many :tasks
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true

  def task_count
    if tasks.count == 1
      "#{tasks.count} Task"
    else
      "#{tasks.count} Tasks"
    end
  end

end

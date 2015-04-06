class Project < ActiveRecord::Base

  has_many :tasks, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :users, through: :memberships, :dependent => :destroy

  validates :name, presence: true

  def task_count
    if tasks.count == 1
      "#{tasks.count} Task"
    else
      "#{tasks.count} Tasks"
    end
  end

  def membership_count
    if memberships.count == 1
      "#{memberships.count} Member"
    else
      "#{memberships.count} Members"
    end
  end

  def task_count_lowercase
    if tasks.count == 1
      "#{tasks.count} task"
    else
      "#{tasks.count} tasks"
    end
  end

  def membership_count_lowercase
    if memberships.count == 1
      "#{memberships.count} membership"
    else
      "#{memberships.count} memberships"
    end
  end

end

class AddTaskCompletedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_completed, :boolean
  end
end

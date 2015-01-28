class RemoveTaskDueDateFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :task_due_date, :date
  end
end

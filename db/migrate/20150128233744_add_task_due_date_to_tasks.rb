class AddTaskDueDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_due_date, :date
  end
end

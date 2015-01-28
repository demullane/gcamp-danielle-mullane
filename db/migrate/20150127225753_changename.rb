class Changename < ActiveRecord::Migration
  def change
    rename_column :tasks, :date, :task_due_date
  end
end

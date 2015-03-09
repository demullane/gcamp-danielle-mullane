class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate
  before_action :set_project

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    @task.project_id = params[:project_id]

    if @task.save
      redirect_to project_tasks_path(@project), notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    old_attrs = @task.attributes
    if @task.update(task_params)
      redirect_to project_tasks_path(@project), notice: 'Task was successfully updated.'
    else
      # replace blank attributes with old params
      new_attrs = {}
      @task.attributes.each do |attr, val|
        if @task.errors.added? attr, :blank
          new_attrs[attr] = old_attrs[attr]
        end
      end
      @task.assign_attributes(new_attrs)
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to project_tasks_path(@project), notice: 'Task was successfully destroyed.'
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def task_params
      params.require(:task).permit(:description, :task_due_date, :task_completed)
    end

    def authenticate
      redirect_to '/signin' unless current_user
      if !current_user
        flash[:notice] = "You must signin first."
      end
    end

end

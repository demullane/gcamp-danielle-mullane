class TasksController < ApplicationController

  before_action :authenticate
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_project
  before_action :member_authentication, only: [:index, :show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
    @comment = Comment.new
    @comments = @task.comments.each do |comment|
      comment.user_exist_check
    end
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
        flash[:notice] = "You must sign in first."
      end
    end

    def member_authentication
      unless @project.users.include?(current_user) || current_user.admin
        redirect_to projects_path, alert: "You do not have access."
      end
    end

end

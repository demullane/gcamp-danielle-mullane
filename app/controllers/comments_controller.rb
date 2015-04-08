class CommentsController < ApplicationController

  before_action :set_comment, only: [:update, :destroy]
  before_action :set_project_task

  def create
    @comment = Comment.new(comment_params)

    @comment.task_id = params[:task_id]
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to project_task_path(@project, @task), notice: 'Comment was successfully created.'
    else
      redirect_to project_task_path(@project, @task)
    end
  end

  def update
  end

  def destroy
  end

  private

  def set_project_task
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:description)
  end

end

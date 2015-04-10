class ProjectsController < ApplicationController

  before_action :find_params, only: [:show, :edit, :update, :destroy, :role_authentication]
  before_action :authenticate
  before_action :role_authentication, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      @membership = Membership.create(project_id: @project.id, user_id: current_user.id, role: "Owner")
      redirect_to project_tasks_path(@project), notice: "Project was successfully created."
    else
      render :new
    end
  end

  def show
  end

  def edit
    unless @role_authentication
      redirect_to @project, alert: "You do not have access."
    end
  end

  def update
    if @role_authentication
      old_attrs = @project.attributes
      if @project.update(project_params)
        redirect_to @project, notice: "Project was successfully updated."
      else
        new_attrs = {}
        @project.attributes.each do |attr, val|
          if @project.errors.added? attr, :blank
            new_attrs[attr] = old_attrs[attr]
          end
        end
        @project.assign_attributes(new_attrs)
        render :edit
      end
    else
      redirect_to @project, alert: "You do not have access."
    end
  end

  def destroy
    if @role_authentication
      @project.destroy
      redirect_to projects_path, notice: "Project was successfully destroyed."
    else
      redirect_to projects_path, alert: "You do not have access."
    end
  end

  def membership_redirect_for_non_member
    @project = Project.find(params[:id])
    redirect_to @project, alert: "You do not have access."
  end

  private

  def find_params
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end

  def authenticate
    redirect_to '/signin' unless current_user
    if !current_user
      flash[:alert] = "You must sign in first."
    end
  end

  def role_authentication
    @project = Project.find(params[:id])
    @role_authentication = @project.users.map{|user| (user.id == current_user.id)} && (@project.memberships.find{ |hash| (hash["project_id"] == @project.id) && (hash["user_id"] == current_user.id) && (hash["role"] = "Owner")})
  end

end

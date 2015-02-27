class ProjectsController < ApplicationController

  before_action :find_params, only: [:show, :edit, :update, :destroy]
  before_action :authenticate

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
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
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully destroyed."
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
    flash[:notice] = "You must sign in first."
  end


end

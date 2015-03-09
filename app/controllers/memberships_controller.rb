class MembershipsController < ApplicationController
  before_action :authenticate
  before_action :set_project

  def index
    @membership = Membership.new
    @memberships = @project.memberships
  end

  def create
    @membership = Membership.new(membership_params)

    @membership.project_id = params[:project_id]

    if @membership.save
      redirect_to project_memberships_path(@project), notice: "#{User.find(@membership.user_id).full_name} was successfully added."
    else
      render :index
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def membership_params
      params.require(:membership).permit(:role, :user_id, :project_id)
    end

    def authenticate
      redirect_to '/signin' unless current_user
      if !current_user
        flash[:notice] = "You must signin first."
      end
    end

end

 class MembershipsController < ApplicationController

  before_action :authenticate
  before_action :set_project
  before_action :set_membership, only: [:update, :destroy]
  before_action :check_last_owner, only: [:update]
  before_action :remove_action_authentication
  before_action :role_authentication, only: [:update]
  before_action :member_authentication

  def index
    @membership = Membership.new
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

  def update
    if @membership.update(membership_params)
      redirect_to project_memberships_path(@project), notice: "#{User.find(@membership.user_id).full_name} was successfully updated."
    else
      render :index
    end
  end

  def destroy
    if (@role_authentication && (@membership.user_id == current_user.id)) || (@membership.user_id == current_user.id)
      @membership.destroy
      redirect_to projects_path, notice: "#{@membership.user.first_name} #{@membership.user.last_name} was successfully removed."
    elsif @role_authentication
      @membership.destroy
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.first_name} #{@membership.user.last_name} was successfully removed."
    else
      redirect_to projects_path, alert: "You do not have access."
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_membership
      @membership = Membership.find(params[:id])
    end

    def membership_params
      params.require(:membership).permit(:role, :user_id, :project_id)
    end

    def authenticate
      redirect_to '/signin' unless current_user
      if !current_user
        flash[:notice] = "You must sign in first."
      end
    end

    def check_last_owner
      if @membership.role == "Owner" && @project.memberships.find_all{|membership| membership.role == "Owner"}.count == 1
        flash[:membership] = "Projects must have at least one owner."
        redirect_to project_memberships_path(@project)
      end
    end

    def remove_action_authentication
      @role_authentication = @project.users.map{|user| (user.id == current_user.id)} && (@project.memberships.find{|hash| (hash["project_id"] == @project.id) && (hash["user_id"] == current_user.id) && (hash["role"] == "Owner")}) || current_user.admin
      @member_authentication = @project.users.include?(current_user) || current_user.admin
    end

    def role_authentication
      unless @role_authentication
        redirect_to project_memberships_path(@project), alert: "You do not have access."
      end
    end

    def member_authentication
      unless @member_authentication
        redirect_to projects_path, alert: "You do not have access."
      end
    end

end

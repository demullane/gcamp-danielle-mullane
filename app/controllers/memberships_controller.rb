class MembershipsController < ApplicationController

  before_action :authenticate
  before_action :set_project
  before_action :set_membership, only: [:update, :destroy]


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
    old_attrs = @membership.attributes
    if @membership.update(membership_params)
      redirect_to project_memberships_path(@project), notice: "#{User.find(@membership.user_id).full_name} was successfully updated."
    else
      # replace blank attributes with old params
      new_attrs = {}
      @membership.attributes.each do |attr, val|
        if @membership.errors.added? attr, :blank
          new_attrs[attr] = old_attrs[attr]
        end
      end
      @membership.assign_attributes(new_attrs)
      render :index
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

end

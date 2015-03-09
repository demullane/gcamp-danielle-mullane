class MembershipsController < ApplicationController

  def index
    @membership = Membership.new
    @project = Project.find(params[:project_id])
  end

  def new

  end

end

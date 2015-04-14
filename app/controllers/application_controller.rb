class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_user, only: [:project_dropdown]

  def current_user
    User.find_by(id: session[:user_id])
  end

  def project_dropdown
    projects = []
    Project.all.each do |project|
      if project.users.include?(current_user)
        projects << project
      end
    end
    return projects
  end

  def marketing_page
    current_page = request.original_url.split('/').last
    return (current_page == 'faq') || (request.original_url.split('/').length == 3) || (current_page == 'terms') || (current_page == 'about') || (current_page == 'signin') || (current_page == 'signup')
  end

  helper_method :current_user, :project_dropdown, :marketing_page

  class CurrentUserAuthentication < StandardError; end

  rescue_from CurrentUserAuthentication, :with => :current_user_authentication

  private

  def current_user_authentication
    render file: "public/current_user_authentication.html", :layout => false, status: 404
  end

end

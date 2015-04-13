class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find_by(id: session[:user_id])
  end

  helper_method :current_user

  class CurrentUserAuthentication < StandardError; end

  rescue_from CurrentUserAuthentication, :with => :current_user_authentication

  private

  def current_user_authentication
    render file: "public/current_user_authentication.html", :layout => false, status: 404
  end
end

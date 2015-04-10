class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find_by(id: session[:user_id])
  end

  helper_method :current_user

  class EditUserAuthentication < StandardError; end

  rescue_from EditUserAuthentication, :with => :edit_user_authentication

  private
  
  def edit_user_authentication
    render file: "public/edit_user_authentication.html", :layout => false, status: 404
  end
end

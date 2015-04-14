class SessionsController < ApplicationController
  before_action :store_referrer, only: [:new]

  def store_referrer
    if request.referer == nil
      session[:return_to] = "/projects/new"
    else
      session[:return_to] = request.referer
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user and @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to session[:return_to], notice: "You have successfully signed in."
    else
      flash[:error] = "Username / password combination is invalid"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path, notice: "You have successfully logged out."
  end

end

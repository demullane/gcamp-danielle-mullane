class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user and @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      # @user.errors[:base] << "Username / password combination is invalid"
      flash[:error] = "Username / password combination is invalid"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end

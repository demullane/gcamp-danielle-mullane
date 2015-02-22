class SessionsController < ApplicationController

  def create
    @user = User.find_by(email: [:user][:email])
    if @user and @user.authentication(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      @user.errors[:base] << 'Invalid'
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end

class UsersController < ApplicationController

  before_action :authenticate
  before_action :find_params, only: [:show, :edit, :update, :destroy, :remove_action_authentication]
  before_action :remove_action_authentication, only: [:show, :edit, :update, :destroy]
  before_action :current_user_auth, only: [:edit, :update, :destroy]

  def index
    @users = []
    users_record = []
    User.all.each do |user|
      current_user.projects.each do |project|
        if (project.users.include?(user)) && !(users_record.include?(user))
          @users << {"#{user.id}":true}
          users_record << user
        end
      end
      if !(users_record.include?(user))
        @users << {"#{user.id}":false}
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
        redirect_to users_path, notice: "User was successfully created."
    else
      render :new
    end
  end

  def show
    @access_to_email = false
    current_user.projects.each do |project|
      if (project.users.include?(@user))
        @access_to_email = true
      end
    end
  end

  def edit
  end

  def update
    old_attrs = @user.attributes

    if @user.update(user_params)
      redirect_to users_path, notice: "User was successfully updated."
    else
      # replace blank attributes with old params
      new_attrs = {}
      @user.attributes.each do |attr, val|
        if @user.errors.added? attr, :blank
          new_attrs[attr] = old_attrs[attr]
        end
      end
      @user.assign_attributes(new_attrs)
      render :edit
    end
  end

  def destroy
    if @user.id == current_user.id
      @user.destroy
      session.clear
      redirect_to root_path, notice: "You have successfully deleted your account."
    else
      redirect_to users_path, notice: "User was successfully destroyed."
    end
  end

  private

  def find_params
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def authenticate
    redirect_to '/signin' unless current_user
    if !current_user
      flash[:alert] = "You must sign in first."
    end
  end

  def remove_action_authentication
    @current_user_authentication = (current_user.id == @user.id)
  end

  def current_user_auth
    raise CurrentUserAuthentication unless @current_user_authentication
  end

end

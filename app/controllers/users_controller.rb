class UsersController < ApplicationController

  before_action :authenticate
  before_action :find_params, only: [:show, :edit, :update, :destroy, :remove_action_authentication, :email_access]
  before_action :remove_action_authentication, only: [:show, :edit, :update, :destroy]
  before_action :current_user_auth, only: [:edit, :update, :destroy]
  before_action :email_access, only: [:show]
  before_action :update_admin_authentication, only: [:update]

  def index
    @users = []
    users_record = []
    User.all.each do |user|
      if (user.id == current_user.id) || current_user.admin
        @users << {"#{user.id}":true}
        users_record << user
      end
      current_user.projects.each do |project|
        if project.users.include?(user) && !(users_record.include?(user))
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
  end

  def edit
  end

  def update
    old_attrs = @user.attributes
    if ((@allowed == "yes") || (@allowed == "no_tamper")) && @user.update(user_params)
      redirect_to users_path, notice: "User was successfully updated."
    elsif (@allowed == "no")
      redirect_to users_path, notice: "You do not have access to make a user an admin."
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
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :admin)
  end

  def authenticate
    redirect_to '/signin' unless current_user
    if !current_user
      flash[:alert] = "You must sign in first."
    end
  end

  def remove_action_authentication
    @user_action_authentication = (current_user.id == @user.id) || current_user.admin
  end

  def current_user_auth
    raise CurrentUserAuthentication unless @user_action_authentication
  end

  def email_access
    @access_to_email = false
    if current_user == @user || current_user.admin
      @access_to_email = true
    else
      current_user.projects.each do |project|
        if (project.users.include?(@user))
          @access_to_email = true
        end
      end
    end
  end

  def update_admin_authentication
    if user_params["admin"] && current_user.admin
      @allowed = "yes"
    elsif !user_params["admin"]
      @allowed = "no_tamper"
    else
      @allowed = "no"
    end
  end

end

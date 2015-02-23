class UsersController < ApplicationController

  before_action :find_params, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
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
    @user.destroy
    redirect_to users_path, notice: "User was successfully destroyed."
  end

  private
  def find_params
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end

require 'rails_helper'

describe UsersController do

  before :each do
    @project = Project.create(name: "Project 1")
    @project2 = Project.create(name: "Project 2")
    @project3 = Project.create(name: "Project 3")
    @project4 = Project.create(name: "Project 4")
    @user = User.create(first_name: "Joe", last_name: "Student", email: "joe@email.com", password: "pass", admin: true)
    @user2 = User.create(first_name: "John", last_name: "Adams", email: "john@email.com", password: "pass", admin: false)
    @user3 = User.create(first_name: "Bill", last_name: "Gates", email: "bill@email.com", password: "pass", admin: false)
    @membership = Membership.create(project_id: @project.id, user_id: @user2.id, role: "Owner")
    @membership2 = Membership.create(project_id: @project2.id, user_id: @user2.id, role: "Member")
    @membership3 = Membership.create(project_id: @project3.id, user_id: @user.id, role: "Member")
    @membership4 = Membership.create(project_id: @project4.id, user_id: @user.id, role: "Member")
    @membership5 = Membership.create(project_id: @project4.id, user_id: @user2.id, role: "Owner")
  end

  describe "GET #index" do
    it "redirects a non-logged in user to /signin" do
      get :index
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /users to the index action in the users controller " do
      session[:user_id] = @user.id
      expect(:get => "/users").to route_to(:controller => "users", :action => "index")
    end

    it "creates array of hashes with user ids and true for all users if user is admin for @users" do
      session[:user_id] = @user.id
      get :index
      expect(assigns(:users)).to match_array([{"#{@user.id}": true}, {"#{@user2.id}": true}, {"#{@user3.id}": true}])
    end

    it "creates array of hashes with user ids and true for all users that are members of projects that the user is also a part of or false otherwise" do
      session[:user_id] = @user2.id
      get :index
      expect(assigns(:users)).to match_array([{"#{@user.id}": true}, {"#{@user2.id}": true}, {"#{@user3.id}": false}])
    end
  end

  describe "GET #new" do
    it "redirects a non-logged in user to /signin" do
      get :new
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /users to the new action in the projects controller" do
      session[:user_id] = @user.id
      expect(:get => "/users/new").to route_to(:controller => "users", :action => "new")
    end

    it "creates a new instance of the users class" do
      session[:user_id] = @user.id
      get :new
      expect(assigns(:user).class).to eq(User)
      expect(assigns(:user).id).to eq(nil)
    end
  end

  describe "POST #create" do
    it "does not allow a non-logged in user to update a user" do
      post :create, user: {"first_name"=>"Larry", "last_name"=>"Cucumber", "email"=>"larry@email.com", "password"=>"pass", "admin"=>true}
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "creates a new user when valid user credentials are present" do
      session[:user_id] = @user.id
      expect{
        post :create, user: {"first_name"=>"Larry", "last_name"=>"Cucumber", "email"=>"larry@email.com", "password"=>"pass", "admin"=>true}
      }.to change(User,:count).by(1)
    end

    it 'redirects to the users_path once the new user is successfully created' do
      session[:user_id] = @user.id
      post :create, user: {"first_name"=>"Larry", "last_name"=>"Cucumber", "email"=>"larry@email.com", "password"=>"pass", "admin"=>true}
      expect(response).to redirect_to("/users")
    end

    it 'renders the page with success message once the new user is successfully created with valid credentials' do
      session[:user_id] = @user.id
      post :create, user: {"first_name"=>"Larry", "last_name"=>"Cucumber", "email"=>"larry@email.com", "password"=>"pass", "admin"=>true}
      expect(flash[:notice]).to match("User was successfully created.")
    end

    it "does not create a new user when invalid user credentials are present" do
      session[:user_id] = @user.id
      expect{
        post :create, user: {"first_name"=>"Larry", "last_name"=>"Cucumber", "email"=>"", "password"=>"pass", "admin"=>true}
      }.to_not change(User,:count)
    end

    it 'renders a new user template if the new user is submitted with invalid credentials' do
      session[:user_id] = @user.id
      post :create, user: {"first_name"=>"Larry", "last_name"=>"Cucumber", "email"=>"", "password"=>"pass", "admin"=>true}
      expect(response).to render_template(:new)
    end
  end

  describe "GET #show" do
    it "redirects a non-logged in user to /signin" do
      get :show, id: @user.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /users/user_id to the show action in the users controller " do
      session[:user_id] = @user.id
      expect(:get => "/users/#{@user.id}").to route_to(:controller => "users", :action => "show", :id => "#{@user.id}")
    end

    it "assigns the requested user to @user" do
      session[:user_id] = @user.id
      get :show, id: @user.id
      expect(assigns(:user)).to eq(@user)
    end

    it "sets @access_to_email to true if the current_user is an admin" do
      session[:user_id] = @user.id
      get :show, id: @user3.id
      expect(assigns(:access_to_email)).to eq(true)
    end

    it "sets @access_to_email to true if the current_user is a member of a project that the user is also a member of" do
      session[:user_id] = @user2.id
      get :show, id: @user.id
      expect(assigns(:access_to_email)).to eq(true)
    end

    it "sets @access_to_email to false if the current_user is not a member of any project that the user a member of" do
      session[:user_id] = @user2.id
      get :show, id: @user3.id
      expect(assigns(:access_to_email)).to eq(false)
    end
  end

  describe "GET #edit" do
    it "redirects a non-logged in user to /signin" do
      get :edit, id: @user.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /users/users_id/edit to the edit action in the users controller" do
      session[:user_id] = @user.id
      expect(:get => "/users/#{@user.id}/edit").to route_to(:controller => "users", :action => "edit", :id => "#{@user.id}")
    end

    it "assigns the requested user to @user if the current_user is an admin" do
      session[:user_id] = @user.id
      get :edit, id: @user2.id
      expect(assigns(:user)).to eq(@user2)
    end

    it "assigns the requested user to @user if the current_user is equal to @user" do
      session[:user_id] = @user2.id
      get :edit, id: @user2.id
      expect(assigns(:user)).to eq(@user2)
    end

    it "redirects a current_user who is neither an admin nor equal to @user" do
      session[:user_id] = @user2.id
      get :edit, id: @user3.id
      expect(response.status).to eq(404)
    end
  end

  describe "POST #update" do
    it "does not allow a non-logged in user to update a project" do
      put :update, id: @user.id, user: {"id"=>@user.id, "first_name"=>"Jim"}
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "located the requested @user" do
      session[:user_id] = @user.id
      put :update, id: @user.id, user: @user.attributes
      expect(assigns(:user)).to eq(@user)
    end

    it "updates @user's attributes" do
      session[:user_id] = @user.id
      put :update, id: @user.id, user: {"id"=>@user.id, "first_name"=>"Jim"}
      @user.reload
      expect(@user.first_name).to eq("Jim")
    end

    it "redirects to the users_path once the user is successfully updated" do
      session[:user_id] = @user.id
      put :update, id: @user.id, user: {"id"=>@user.id, "first_name"=>"Jim"}
      expect(response).to redirect_to(users_path)
    end

    it "renders the page with success message once the user is successfully updated with valid credentials" do
      session[:user_id] = @user.id
      put :update, id: @user.id, user: {"id"=>@user.id, "first_name"=>"Jim"}
      expect(flash[:notice]).to match("User was successfully updated.")
    end

    it "does not change @user's attributes when invalid credentials are present" do
      session[:user_id] = @user.id
      put :update, id: @user, user: {"id"=>@user.id, "first_name"=>""}
      @user.reload
      expect(@user.first_name).to eq("Joe")
    end

    it 'renders the edit user template if the user is submitted with invalid credentials' do
      session[:user_id] = @user.id
      put :update, id: @user, user: {"id"=>@user.id, "first_name"=>""}
      expect(response).to render_template(:edit)
    end

    it "does not allow a current_user who is neither an admin nor equal to @user to update @user" do
      session[:user_id] = @user2.id
      put :update, id: @user.id, user: {"id"=>@user.id, "name"=>"Jim"}
      expect(@user.first_name).to eq("Joe")
      expect(response.status).to eq(404)
    end
  end

  describe "DELETE #destroy" do
    it "does not allow a non-logged in user to delete a user" do
      delete :destroy, id: @user
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "deletes the user" do
      session[:user_id] = @user.id
      expect{delete :destroy, id: @user}.to change(User,:count).by(-1)
    end

    it "redirects to users index" do
      session[:user_id] = @user.id
      delete :destroy, id: @user2
      expect(response).to redirect_to(users_path)
    end

    it "renders the page with success message once the user is successfully destroyed" do
      session[:user_id] = @user.id
      delete :destroy, id: @user2
      expect(flash[:notice]).to match("User was successfully destroyed.")
    end

    it "does not allow a current_user who is neither an admin nor equal to @user to destroy @user" do
      session[:user_id] = @user2.id
      delete :destroy, id: @user3.id
      expect(User.exists?(@user3.id)).to eq(true)
      expect(response.status).to eq(404)
    end
  end

end

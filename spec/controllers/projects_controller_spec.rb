require 'rails_helper'

describe ProjectsController do

  before :each do
    @project = Project.create(name: "Project 1")
    @project2 = Project.create(name: "Project 2")
    @project3 = Project.create(name: "Project 3")
    @user = User.create(first_name: "Joe", last_name: "Student", email: "joe@email.com", password: "pass", admin: true)
    @user2 = User.create(first_name: "John", last_name: "Adams", email: "john@email.com", password: "pass", admin: false)
    @membership = Membership.create(project_id: @project.id, user_id: @user2.id, role: "Owner")
    @membership2 = Membership.create(project_id: @project2.id, user_id: @user2.id, role: "Member")
    @membership3 = Membership.create(project_id: @project3.id, user_id: @user.id, role: "Member")
  end

  describe "GET #index" do
    it "redirects a non-logged in user to /signin" do
      get :index
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /projects to the index action in the projects controller " do
      session[:user_id] = @user.id
      expect(:get => "/projects").to route_to(:controller => "projects", :action => "index")
    end

    it "loads all projects into @projects" do
      session[:user_id] = @user.id
      get :index
      expect(assigns(:projects)).to match_array([@project, @project2, @project3])
    end

    it "creates array of hashes with project id and true for all projects if user is admin for @filtered_projects" do
      session[:user_id] = @user.id
      get :index
      expect(assigns(:filtered_projects)).to match_array([{"#{@project.id}": true}, {"#{@project2.id}": true}, {"#{@project3.id}": true}])
    end

    it "creates array of hashes with project ids of projects the user is a part of and true for all projects that the user is an owner of for @filtered_projects" do
      session[:user_id] = @user2.id
      get :index
      expect(assigns(:filtered_projects)).to match_array([{"#{@project.id}": true}, {"#{@project2.id}": false}])
    end
  end

  describe "GET #new" do
    it "redirects a non-logged in user to /signin" do
      get :new
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /projects to the new action in the projects controller " do
      session[:user_id] = @user.id
      expect(:get => "/projects/new").to route_to(:controller => "projects", :action => "new")
    end

    it "creates a new instance of the projects class" do
      session[:user_id] = @user.id
      get :new
      expect(assigns(:project).class).to eq(Project)
      expect(assigns(:project).id).to eq(nil)
    end
  end

  describe "POST #create" do
    it "does not allow a non-logged in user to update a project" do
      post :create, project: {"name"=>"Project #4"}
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "creates a new project when valid project credentials are present" do
      session[:user_id] = @user.id
      expect{
        post :create, project: {"name"=>"Project #4"}
      }.to change(Project,:count).by(1)
    end

    it 'redirects to the project_tasks_path once the new project is successfully created' do
      session[:user_id] = @user.id
      post :create, project: {"name"=>"Project #4"}
      expect(response).to redirect_to("/projects/#{Project.last.id}/tasks")
    end

    it 'renders the page with success message once the new project is successfully created with valid credentials' do
      session[:user_id] = @user.id
      post :create, project: {"name"=>"Project #4"}
      expect(flash[:notice]).to match("Project was successfully created.")
    end

    it "does not create a new project when invalid project credentials are present" do
      session[:user_id] = @user.id
      expect{
        post :create, project: {"name"=>""}
      }.to_not change(Project,:count)
    end

    it 'renders a new project template if the new project is submitted with invalid credentials' do
      session[:user_id] = @user.id
      post :create, project: {"name"=>""}
      expect(response).to render_template(:new)
    end
  end

  describe "GET #show" do
    it "redirects a non-logged in user to /signin" do
      get :show, id: @project.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /projects/project_id to the show action in the projects controller " do
      session[:user_id] = @user.id
      expect(:get => "/projects/#{@project.id}").to route_to(:controller => "projects", :action => "show", :id => "#{@project.id}")
    end

    it "assigns the requested project to @project if the user is an admin" do
      session[:user_id] = @user.id
      get :show, id: @project.id
      expect(assigns(:project)).to eq(@project)
    end

    it "assigns the requested project to @project if the user is a member of the requested project" do
      session[:user_id] = @user2.id
      get :show, id: @project2.id
      expect(assigns(:project)).to eq(@project2)
    end

    it "redirects a user who is neither an admin nor a member of the requested project to /projects" do
      session[:user_id] = @user2.id
      get :show, id: @project3.id
      expect(response).to redirect_to(projects_path)
    end

    it "renders the page with error message if the user is neither an admin nor a member of the requested project" do
      session[:user_id] = @user2.id
      get :show, id: @project3.id
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "GET #edit" do
    it "redirects a non-logged in user to /signin" do
      get :edit, id: @project.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /projects/project_id/edit to the edit action in the projects controller" do
      session[:user_id] = @user.id
      expect(:get => "/projects/#{@project.id}/edit").to route_to(:controller => "projects", :action => "edit", :id => "#{@project.id}")
    end

    it "assigns the requested project to @project if the user is an admin" do
      session[:user_id] = @user.id
      get :edit, id: @project.id
      expect(assigns(:project)).to eq(@project)
    end

    it "assigns the requested project to @project if the user is a member of the requested project" do
      session[:user_id] = @user2.id
      get :edit, id: @project2.id
      expect(assigns(:project)).to eq(@project2)
    end

    it "redirects a user who is neither an admin nor a member of the requested project to /projects" do
      session[:user_id] = @user2.id
      get :edit, id: @project3.id
      expect(response).to redirect_to(project_path(@project3))
    end

    it "renders the page with error message if the user is neither an admin nor a member of the requested project" do
      session[:user_id] = @user2.id
      get :edit, id: @project3.id
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "POST #update" do
    it "does not allow a non-logged in user to update a project" do
      put :update, id: @project.id, project: {"id"=>@project.id, "name"=>"Project 1 Updated"}
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "located the requested @project" do
      session[:user_id] = @user.id
      put :update, id: @project.id, project: @project.attributes
      expect(assigns(:project)).to eq(@project)
    end

    it "updates @project's attributes" do
      session[:user_id] = @user.id
      put :update, id: @project.id, project: {"id"=>@project.id, "name"=>"Project 1 Updated"}
      @project.reload
      expect(@project.name).to eq("Project 1 Updated")
    end

    it "redirects to the project_path once the project is successfully updated" do
      session[:user_id] = @user.id
      put :update, id: @project.id, project: {"id"=>@project.id, "name"=>"Project 1 Updated"}
      expect(response).to redirect_to @project
    end

    it "renders the page with success message once the project is successfully updated with valid credentials" do
      session[:user_id] = @user.id
      put :update, id: @project.id, project: {"id"=>@project.id, "name"=>"Project 1 Updated"}
      expect(flash[:notice]).to match("Project was successfully updated.")
    end

    it "does not change @project's attributes when invalid credentials are present" do
      session[:user_id] = @user.id
      put :update, id: @project, project: {"id"=>@project.id, "name"=>""}
      @project.reload
      expect(@project.name).to eq("Project 1")
    end

    it 'renders the edit project template if the project is submitted with invalid credentials' do
      session[:user_id] = @user.id
      put :update, id: @project, project: {"id"=>@project.id, "name"=>""}
      expect(response).to render_template(:edit)
    end

    it "does not allow a user who is neither an admin nor a member of the project to update the project" do
      session[:user_id] = @user2.id
      put :update, id: @project3.id, project: {"id"=>@project3.id, "name"=>"Project 3 Updated"}
      expect(@project3.name).to eq("Project 3")
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "DELETE #destroy" do
    it "does not allow a non-logged in user to delete a project" do
      delete :destroy, id: @project
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "deletes the project" do
      session[:user_id] = @user2.id
      expect{delete :destroy, id: @project}.to change(Project,:count).by(-1)
    end

    it "redirects to projects index" do
      session[:user_id] = @user2.id
      delete :destroy, id: @project
      expect(response).to redirect_to(projects_path)
    end

    it "renders the page with success message once the project is successfully destroyed" do
      session[:user_id] = @user2.id
      delete :destroy, id: @project
      expect(flash[:notice]).to match("Project was successfully destroyed.")
    end

    it "does not allow a user who is neither an admin nor a member of the project to delete the project" do
      session[:user_id] = @user2.id
      delete :destroy, id: @project3.id
      expect(Project.exists?(@project3.id)).to eq(true)
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

end

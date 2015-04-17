require 'rails_helper'

describe TasksController do

  before :each do
    @project = Project.create(name: "Project 1")
    @project2 = Project.create(name: "Project 2")
    @project3 = Project.create(name: "Project 3")
    @task = Task.create(description: "Task 1 for Project 1", project_id: @project.id)
    @task1b = Task.create(description: "Task 2 for Project 1", project_id: @project.id)
    @task2 = Task.create(description: "Task 1 for Project 2", project_id: @project2.id)
    @task3 = Task.create(description: "Task 1 for Project 3", project_id: @project3.id)
    @user = User.create(first_name: "Joe", last_name: "Student", email: "joe@email.com", password: "pass", admin: true)
    @user2 = User.create(first_name: "John", last_name: "Adams", email: "john@email.com", password: "pass", admin: false)
    @membership = Membership.create(project_id: @project.id, user_id: @user2.id, role: "Owner")
    @membership2 = Membership.create(project_id: @project2.id, user_id: @user2.id, role: "Member")
    @membership3 = Membership.create(project_id: @project3.id, user_id: @user.id, role: "Member")
  end

  describe "GET #index" do
    it "redirects a non-logged in user to /signin" do
      get :index, project_id: @project.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /project/project_id/tasks to the index action in the tasks controller" do
      session[:user_id] = @user.id
      expect(:get=>"/projects/#{@project.id}/tasks").to route_to(:controller => "tasks", :action => "index", :project_id => @project.id.to_s)
    end

    it "loads all tasks into @tasks" do
      session[:user_id] = @user.id
      get :index, project_id: @project.id
      expect(assigns(:tasks)).to match_array([@task, @task1b])
    end

    it "redirects a user who is neither an admin nor a member of the project to /projects" do
      session[:user_id] = @user2.id
      get :index, project_id: @project3.id
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "GET #new" do
    it "redirects a non-logged in user to /signin" do
      get :new, project_id: @project.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /projects/project_id/tasks/new to the new action in the tasks controller" do
      session[:user_id] = @user.id
      expect(:get=>"/projects/#{@project.id}/tasks/new").to route_to(:controller => "tasks", :action => "new", :project_id => @project.id.to_s)
    end

    it "creates a new instance of the task class" do
      session[:user_id] = @user.id
      get :new, project_id: @project.id
      expect(assigns(:task).class).to eq(Task)
      expect(assigns(:task).id).to eq(nil)
    end

    it "redirects a user who is neither an admin nor a member of the project to /projects" do
      session[:user_id] = @user2.id
      get :new, project_id: @project3.id
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "POST #create" do
    it "does not allow a non-logged in user to update a project" do
      post :create, project_id: @project3.id, task: {"description"=>"Task 1 for Project 3", "project_id"=>@project3.id}
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "creates a new task when valid task credentials are present" do
      session[:user_id] = @user.id
      expect{
        post :create, project_id: @project3.id, task: {"description"=>"Task 1 for Project 3", "project_id"=>@project3.id}
      }.to change(Task,:count).by(1)
    end

    it 'redirects to the project_tasks_path once the new task is successfully created' do
      session[:user_id] = @user.id
      post :create, project_id: @project3.id, task: {"description"=>"Task 1 for Project 3", "project_id"=>@project3.id}
      expect(response).to redirect_to("/projects/#{Project.last.id}/tasks")
    end

    it 'renders the page with success message once the new task is successfully created with valid credentials' do
      session[:user_id] = @user.id
      post :create, project_id: @project3.id, task: {"description"=>"Task 1 for Project 3", "project_id"=>@project3.id}
      expect(flash[:notice]).to match("Task was successfully created.")
    end

    it "does not create a new task when the description field is left blank" do
      session[:user_id] = @user.id
      expect{
        post :create, project_id: @project3.id, task: {"description"=>"", "project_id"=>@project3.id}
      }.to_not change(Task,:count)
    end

    it 'renders a new task template if the new task is submitted with invalid credentials' do
      session[:user_id] = @user.id
      post :create, project_id: @project3.id, task: {"description"=>"", "project_id"=>@project3.id}
      expect(response).to render_template(:new)
    end

    it "redirects a user who is neither an admin nor a member of the project to /projects" do
      session[:user_id] = @user2.id
      post :create, project_id: @project3.id, task: {"description"=>"Task 1 for Project 3", "project_id"=>@project3.id}
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "GET #show" do
    it "redirects a non-logged in user to /signin" do
      get :show, project_id: @project.id, id: @task.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /projects/project_id/tasks/task_id to the show action in the tasks controller " do
      session[:user_id] = @user.id
      expect(:get => "/projects/#{@project.id}/tasks/#{@task.id}").to route_to(:controller => "tasks", :action => "show", :project_id => @project.id.to_s, :id => @task.id.to_s)
    end

    it "assigns the requested task to @task if the user is an admin" do
      session[:user_id] = @user.id
      get :show, project_id: @project.id, id: @task.id
      expect(assigns(:task)).to eq(@task)
    end

    it "assigns the requested task to @task if the user is a member of the requested project" do
      session[:user_id] = @user2.id
      get :show, project_id: @project2.id, id: @task2.id
      expect(assigns(:task)).to eq(@task2)
    end

    it "creates a new instance of the comment class" do
      session[:user_id] = @user.id
      get :show, project_id: @project.id, id: @task.id
      expect(assigns(:comment).class).to eq(Comment)
      expect(assigns(:comment).id).to eq(nil)
    end

    it "loads all task comments into @comments" do
      @comment = Comment.create(description: "Comment 1 for Project 2/Task 2", task_id: @task2.id, user_id: @user2.id)
      @comment2 = Comment.create(description: "Comment 2 for Project 2/Task 2", task_id: @task2.id, user_id: @user2.id)
      session[:user_id] = @user2.id
      get :show, project_id: @project2.id, id: @task2.id
      expect(assigns(:comments)).to match_array([@comment, @comment2])
    end

    it "redirects a user who is neither an admin nor a member of the requested project to /projects" do
      session[:user_id] = @user2.id
      get :show, project_id: @project3.id, id: @task3.id
      expect(response).to redirect_to(projects_path)
    end

    it "renders the page with error message if the user is neither an admin nor a member of the requested project" do
      session[:user_id] = @user2.id
      get :show, project_id: @project3.id, id: @task3.id
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "GET #edit" do
    it "redirects a non-logged in user to /signin" do
      get :edit, project_id: @project.id, id: @task.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "routes /projects/project_id/tasks/task_id/edit to the edit action in the tasks controller" do
      session[:user_id] = @user.id
      expect(:get => "/projects/#{@project.id}/tasks/#{@task.id}/edit").to route_to(:controller => "tasks", :action => "edit", :project_id => @project.id.to_s, :id => @task.id.to_s)
    end

    it "assigns the requested task to @task if the user is an admin" do
      session[:user_id] = @user.id
      get :edit, project_id: @project.id, id: @task.id
      expect(assigns(:task)).to eq(@task)
    end

    it "assigns the requested project to @project if the user is a member of the requested project" do
      session[:user_id] = @user2.id
      get :edit, project_id: @project2.id, id: @task2.id
      expect(assigns(:task)).to eq(@task2)
    end

    it "redirects a user who is neither an admin nor a member of the requested project to /projects" do
      session[:user_id] = @user2.id
      get :edit, project_id: @project3.id, id: @task3.id
      expect(response).to redirect_to(projects_path)
    end

    it "renders the page with error message if the user is neither an admin nor a member of the requested project" do
      session[:user_id] = @user2.id
      get :edit, project_id: @project3.id, id: @task3.id
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "POST #update" do
    it "does not allow a non-logged in user to update a task" do
      put :update, project_id: @project.id, id: @task.id, task: { "id"=>@task.id, "description"=>"Task 1 for Project 1 Updated", "project_id"=>@project.id}
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "located the requested @task" do
      session[:user_id] = @user.id
      put :update, project_id: @project.id, id: @task.id, task: @task.attributes
      expect(assigns(:task)).to eq(@task)
    end

    it "updates @task's attributes" do
      session[:user_id] = @user.id
      put :update, project_id: @project.id, id: @task.id, task: { "id"=>@task.id, "description"=>"Task 1 for Project 1 Updated", "project_id"=>@project.id}
      @task.reload
      expect(@task.description).to eq("Task 1 for Project 1 Updated")
    end

    it "redirects to the tasks_path once the task is successfully updated" do
      session[:user_id] = @user.id
      put :update, project_id: @project.id, id: @task.id, task: { "id"=>@task.id, "description"=>"Task 1 for Project 1 Updated", "project_id"=>@project.id}
      expect(response).to redirect_to(project_tasks_path(@project))
    end

    it "renders the page with success message once the task is successfully updated with valid credentials" do
      session[:user_id] = @user.id
      put :update, project_id: @project.id, id: @task.id, task: { "id"=>@task.id, "description"=>"Task 1 for Project 1 Updated", "project_id"=>@project.id}
      expect(flash[:notice]).to match("Task was successfully updated.")
    end

    it "does not change @task's attributes when invalid credentials are present" do
      session[:user_id] = @user.id
      put :update, project_id: @project.id, id: @task.id, task: { "id"=>@task.id, "description"=>"", "project_id"=>@project.id}
      @task.reload
      expect(@task.description).to eq("Task 1 for Project 1")
    end

    it 'renders the edit task template if the task is submitted with invalid credentials' do
      session[:user_id] = @user.id
      put :update, project_id: @project.id, id: @task.id, task: { "id"=>@task.id, "description"=>"", "project_id"=>@project.id}
      expect(response).to render_template(:edit)
    end

    it "does not allow a user who is neither an admin nor a member of the project to update the task" do
      session[:user_id] = @user2.id
      put :update, project_id: @project3.id, id: @task3.id, task: { "id"=>@task3.id, "description"=>"Task 1 for Project 3 Updated", "project_id"=>@project3.id}
      expect(@task3.description).to eq("Task 1 for Project 3")
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

  describe "DELETE #destroy" do
    it "does not allow a non-logged in user to delete a project" do
      delete :destroy, project_id: @project.id, id: @task.id
      expect(response).to redirect_to('/signin')
      expect(flash[:alert]).to match("You must sign in first.")
    end

    it "deletes the project" do
      session[:user_id] = @user2.id
      expect{delete :destroy, project_id: @project.id, id: @task.id}.to change(Task,:count).by(-1)
    end

    it "redirects to tasks index" do
      session[:user_id] = @user2.id
      delete :destroy, project_id: @project.id, id: @task.id
      expect(response).to redirect_to(project_tasks_path(@project))
    end

    it "renders the page with success message once the project is successfully destroyed" do
      session[:user_id] = @user2.id
      delete :destroy, project_id: @project.id, id: @task.id
      expect(flash[:notice]).to match("Task was successfully destroyed.")
    end

    it "does not allow a user who is neither an admin nor a member of the project to delete the project" do
      session[:user_id] = @user2.id
      delete :destroy, project_id: @project3.id, id: @task3.id
      expect(Task.exists?(@task3.id)).to eq(true)
      expect(flash[:alert]).to match("You do not have access.")
    end
  end

end

require 'rails_helper'

describe 'User can use the tasks page succesfully (CRUD)' do

  before :each do
    @user = User.create(first_name: "Joe", last_name: "Student", email: "joestudent@email.com", password: "password", admin: false)
    @project = Project.create(name: "Project 1")
    @task = Task.create(description: "Task 1 for Project 1.", task_due_date: "2015-07-28", project_id: @project.id)
    @membership = Membership.create(project_id: @project.id, user_id: @user.id, role: "Owner")

    visit '/signin'
    fill_in "Email", with: "joestudent@email.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    visit "/projects/#{@project.id}/tasks"
  end

  scenario 'Task total shows on projects index page' do
    visit "/projects"
    expect(page).to have_content("Project 1")
    expect(page).to have_content(1)
  end

  scenario 'Task total shows on project show page with singular task' do
    visit "/projects/#{@project.id}"
    expect(page).to have_content("1 Task")
  end

  scenario 'Task total shows on project show page with plural tasks' do
    Task.create(description: "Task 2 for Project 1", task_due_date: "2016-05-28", project_id: @project.id)
    visit "/projects/#{@project.id}"

    expect(page).to have_content("2 Tasks")
  end

  scenario 'User creates a new task' do
    click_on "New Task"

    fill_in "Description", with: "This is a new task."
    select "2015", from: 'task[task_due_date(1i)]'
    select "July", from: 'task[task_due_date(2i)]'
    select "28", from: 'task[task_due_date(3i)]'

    click_on "Create Task"

    expect(page).to have_content("Task was successfully created.")
    expect(page).to have_content("2015-07-28")
    expect(page).to have_content("This is a new task.")
    expect(page).to have_content("Projects")
    expect(page).to have_content("Project 1")
    expect(page).to have_selector("li", :text => "Tasks")
    expect(page).to have_selector("h1", :text => "Tasks for Project 1")
  end

  scenario 'User updates a task via tasks index page' do
    click_on "Edit"

    fill_in "Description", with: "Task 1 for Project 1 Updated"
    check "Completed"

    click_on "Update Task"

    expect(page).to have_content("Task was successfully updated.")
    expect(page).to have_content("Task 1 for Project 1 Updated")
    expect(page).to have_content(true)
    expect(page).to have_content("2015-07-28")
  end

  scenario 'User updates a task via task show page' do
    click_on "Task 1 for Project 1"

    expect(page).to have_selector("h1", :text => "Task 1 for Project 1")
    expect(page).to have_content("Due On: 2015-07-28")
    expect(page).to have_content("Projects")
    expect(page).to have_selector("li", :text => "Tasks")
    expect(page).to have_selector("li", :text => "Task 1 for Project 1")

    click_on "Edit"

    fill_in "Description", with: "Task 1 for Project 1 Updated"
    check "Completed"

    click_on "Update Task"

    expect(page).to have_content("Task was successfully updated.")
    expect(page).to have_content("Task 1 for Project 1 Updated")
    expect(page).to have_content(true)
    expect(page).to have_content("2015-07-28")
  end

  scenario 'User deletes a task via tasks index page' do
    page.find("#task_delete").click

    expect(page).to have_content("Task was successfully destroyed.")
    expect(page).to_not have_content("This is a test.")
  end

  scenario 'User creates a new task with blank description field' do
    click_on "New Task"

    click_on "Create Task"

    expect(page).to have_content("Description can't be blank")
  end

  scenario 'User edits an existing task and saves with blank description field' do
    click_on "Task 1 for Project 1"

    click_on "Edit"

    fill_in "Description", with: ""

    click_on "Update Task"

    expect(page).to have_content("Description can't be blank")
  end

end

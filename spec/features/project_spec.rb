require 'rails_helper'

describe 'User can use the projects page succesfully (CRUD)' do

  before :each do
    User.create(first_name: "Joe", last_name: "Student", email: "joestudent@email.com", password: "password")
    Project.create(name: "Test Project")
    Membership.create(project_id: Project.last.id, user_id: User.last.id, role: "Owner")

    visit '/signin'
    fill_in "Email", with: "joestudent@email.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    visit '/projects'
  end


  scenario 'User creates a new project' do
    within "#new-project-button-div" do
      click_link "New Project"
    end

    fill_in "Name", with: "Test Project #2"

    click_on "Create Project"

    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Tasks for Test Project #2")
    expect(page).to have_content("New Task")
  end

  scenario 'User updates a project via projects index page' do
    click_on "Edit"

    fill_in "Name", with: "Test Project Update"

    click_on "Update Project"

    expect(page).to have_content("Project was successfully updated.")
    expect(page).to have_content("Test Project Update")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")
  end

  scenario 'User updates a project via project show page' do
    within "table" do
      click_on "Test Project"
    end

    expect(page).to have_content("Test Project")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")

    click_on "Edit"

    fill_in "Name", with: "Test Project Update"

    click_on "Update Project"

    expect(page).to have_content("Project was successfully updated.")
    expect(page).to have_content("Test Project Update")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")
  end

  scenario 'User deletes a project via projects index page' do
    click_on "Delete"

    expect(page).to have_content("Project was successfully destroyed.")
    expect(page).to_not have_content("Test Project")
  end

  scenario 'User deletes a project via project show page' do
    within "table" do
      click_on "Test Project"
    end

    expect(page).to have_content("Test Project")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")

    click_on "Delete"

    expect(page).to have_content("Project was successfully destroyed.")
    expect(page).to have_content("Projects")
    expect(page).to_not have_content("Test Project")
  end

  scenario 'User creates a new project with blank name field' do
    within "#new-project-button-div" do
      click_link "New Project"
    end

    click_on "Create Project"

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'User edits an existing project and saves with blank name field' do
    click_on "Edit"

    fill_in "Name", with: ""

    click_on "Update Project"

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'When a user deletes a project all related tasks are also deleted' do
    task1 = Task.create(description: "Task 1 for Test Project", project_id: Project.last.id)
    task2 = Task.create(description: "Task 2 for Test Project", project_id: Project.last.id)

    click_on "Delete"

    expect(Task.all.length == 0)
  end
end

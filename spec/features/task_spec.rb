require 'rails_helper'

describe 'User can use the tasks page succesfully (CRUD)' do

  before :each do
    User.create(first_name: "Joe", last_name: "Student", email: "joestudent@email.com", password: "password")
    Task.create(description: "This is a test.", task_due_date: "2015-07-28")

    visit '/signin'
    fill_in "Email", with: "joestudent@email.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    visit '/tasks'
  end


  scenario 'User creates a new task' do

    click_on "New Task"

    fill_in "Description", with: "This is a new task."
    select "2015", from: 'task[task_due_date(1i)]'
    select "July", from: 'task[task_due_date(2i)]'
    select "28", from: 'task[task_due_date(3i)]'

    click_on "Create Task"

    expect(page).to have_content("Task was successfully created.")
    expect(page).to have_content("Due On: 2015-07-28")
    expect(page).to have_content("Edit")

  end

  scenario 'User updates a task via tasks index page' do

    click_on "Edit"

    fill_in "Description", with: "This is an updated task."
    check "Completed"

    click_on "Update Task"

    expect(page).to have_content("Task was successfully updated.")
    expect(page).to have_content("This is an updated task.")
    expect(page).to have_content("Due On: 2015-07-28")
    expect(page).to have_content("Edit")

  end

  scenario 'User updates a task via task show page' do

    click_on "This is a test."

    expect(page).to have_content("This is a test.")
    expect(page).to have_content("Due On: 2015-07-28")

    click_on "Edit"

    fill_in "Description", with: "This is an updated task."
    check "Completed"

    click_on "Update Task"

    expect(page).to have_content("Task was successfully updated.")
    expect(page).to have_content("This is an updated task.")
    expect(page).to have_content("Due On: 2015-07-28")
    expect(page).to have_content("Edit")

  end

  scenario 'User deletes a task via tasks index page' do

    click_on "Delete"

    expect(page).to have_content("Task was successfully destroyed.")
    expect(page).to_not have_content("This is a test.")

  end

  #scenario 'User deletes a task via task edit page' do

    #click_on "Edit"

    #click_on "Delete"

    #expect(page).to have_content("Task was successfully destroyed.")
    #expect(page).to_not have_content("This is a test.")

  #end

  #scenario 'User deletes a task via task show page' do

    #click_on "This is a test."

    #expect(page).to have_content("This is a test.")
    #expect(page).to have_content("Due On: 2015-07-28")

    #click_on "Delete"

    #expect(page).to have_content("Task was successfully destroyed.")
    #expect(page).to_not have_content("This is a test.")

  #end

  scenario 'User creates a new task with blank description field' do

    click_on "New Task"

    click_on "Create Task"

    expect(page).to have_content("Description can't be blank")

  end

  scenario 'User edits an existing task and saves with blank description field' do

    click_on "Edit"

    fill_in "Description", with: ""

    click_on "Update Task"

    expect(page).to have_content("Description can't be blank")

  end

end

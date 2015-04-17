require 'rails_helper'

describe 'User can use the users page succesfully (CRUD)' do

  before :each do
    # @project = Project.create(name: "Project 1")
    # @project2 = Project.create(name: "Project 2")
    # @project3 = Project.create(name: "Project 3")
    # @project4 = Project.create(name: "Project 4")
    @user = User.create(first_name: "Joe", last_name: "Student", email: "joe@email.com", password: "pass", admin: true)
    # @user2 = User.create(first_name: "John", last_name: "Adams", email: "john@email.com", password: "pass", admin: false)
    # @user3 = User.create(first_name: "Bill", last_name: "Gates", email: "bill@email.com", password: "pass", admin: false)
    # @membership = Membership.create(project_id: @project.id, user_id: @user2.id, role: "Owner")
    # @membership2 = Membership.create(project_id: @project2.id, user_id: @user2.id, role: "Member")
    # @membership3 = Membership.create(project_id: @project3.id, user_id: @user.id, role: "Member")
    # @membership4 = Membership.create(project_id: @project4.id, user_id: @user.id, role: "Member")
    # @membership5 = Membership.create(project_id: @project4.id, user_id: @user2.id, role: "Owner")

    visit '/signin'
    fill_in "Email", with: "joe@email.com"
    fill_in "Password", with: "pass"
    click_button "Sign In"

    visit '/users'
  end


  scenario 'User creates a new user' do
    click_on "New User"

    fill_in "First Name", with: "Bob"
    fill_in "Last Name", with: "Smith"
    fill_in "Email", with: "bobsmith@email.com"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    click_on "Create User"

    expect(page).to have_content("User was successfully created.")
    expect(page).to have_content("Bob Smith")
    expect(page).to have_content("bobsmith@email.com")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")
  end

  scenario 'User updates a user via users index page' do
    click_on "Edit"

    fill_in "Email", with: "updated@email.com"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"

    click_on "Update User"

    expect(page).to have_content("User was successfully updated.")
    expect(page).to have_content("Joe Student")
    expect(page).to have_content("updated@email.com")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")
  end

  scenario 'User updates a user via user show page' do
    within "table" do
      click_on "Joe Student"
    end

    expect(page).to have_content("First Name: Joe")
    expect(page).to have_content("Last Name: Student")
    expect(page).to have_content("Email: joe@email.com")

    click_on "Edit"

    fill_in "Email", with: "updated@email.com"
    fill_in "Password", with: "pass"
    fill_in "Password Confirmation", with: "pass"

    click_on "Update User"

    expect(page).to have_content("User was successfully updated.")
    expect(page).to have_content("Joe Student")
    expect(page).to have_content("updated@email.com")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")
  end

  scenario 'User deletes a user via user edit page' do
    @user2 = User.create(first_name: "John", last_name: "Adams", email: "john@email.com", password: "pass", admin: false)
    visit "/users/#{@user2.id}"

    click_on "Edit"

    click_on "Delete"

    expect(page).to have_content("User was successfully destroyed.")
    expect(page).to_not have_content("John Adams")
    expect(page).to_not have_content("john@email.com")
  end

  scenario 'User deletes a user via user show page' do
    @user2 = User.create(first_name: "John", last_name: "Adams", email: "john@email.com", password: "pass", admin: false)
    visit "/users/#{@user2.id}"

    expect(page).to have_content("First Name: John")
    expect(page).to have_content("Last Name: Adams")
    expect(page).to have_content("Email: john@email.com")

    click_on "Delete"

    expect(page).to have_content("User was successfully destroyed.")
    expect(page).to_not have_content("John Adams")
    expect(page).to_not have_content("john@email.com")
  end

  scenario 'User creates a new user without filling in form fields' do

    click_on "New User"

    click_on "Create User"

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")

  end

  scenario 'User creates a new user with mismatching password and password confirmation fields' do

    click_on "New User"

    click_on "Create User"

    fill_in "First Name", with: "Bob"
    fill_in "Last Name", with: "Smith"
    fill_in "Email", with: "bobsmith@email.com"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "pass"
    click_on "Create User"

    expect(page).to have_content("Password confirmation doesn't match Password")

  end

  scenario 'User edits an existing user and saves with blank fields' do

    click_on "Edit"

    fill_in "First Name", with: ""
    fill_in "Last Name", with: ""
    fill_in "Email", with: ""

    click_on "Update User"

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email can't be blank")

  end

  scenario 'User edits and existing user and saves with mismatching password and password confirmation fields' do
    within 'table' do
      click_on "Joe Student"
    end
    
    click_on "Edit"

    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "pass"
    click_on "Update User"

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  scenario 'User creates a new user with an invalid email address' do

    click_on "New User"

    fill_in "First Name", with: "Bob"
    fill_in "Last Name", with: "Smith"
    fill_in "Email", with: "bobsmithemail.com"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"

    click_on "Create User"

    expect(page).to have_content("New User")

  end

end

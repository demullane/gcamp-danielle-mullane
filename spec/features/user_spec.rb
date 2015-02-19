require 'rails_helper'

describe 'User can use the users page succesfully (CRUD)' do

  before :each do
    User.create(first_name: "Joe", last_name: "Student", email: "joestudent@email.com")
    visit '/users'
  end


  scenario 'User creates a new user' do

    click_on "New User"

    fill_in "First Name", with: "Bob"
    fill_in "Last Name", with: "Smith"
    fill_in "Email", with: "bobsmith@email.com"

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

    click_on "Update User"

    expect(page).to have_content("User was successfully updated.")
    expect(page).to have_content("Joe Student")
    expect(page).to have_content("updated@email.com")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")

  end

  scenario 'User updates a user via user show page' do

    click_on "Joe Student"

    expect(page).to have_content("First Name: Joe")
    expect(page).to have_content("Last Name: Student")
    expect(page).to have_content("Email: joestudent@email.com")

    click_on "Edit"

    fill_in "Email", with: "updated@email.com"

    click_on "Update User"

    expect(page).to have_content("User was successfully updated.")
    expect(page).to have_content("Joe Student")
    expect(page).to have_content("updated@email.com")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")

  end

  scenario 'User deletes a user via users index page' do

    click_on "Delete"

    expect(page).to have_content("User was successfully destroyed.")
    expect(page).to_not have_content("Joe Student")
    expect(page).to_not have_content("joestudent@email.com")

  end

  scenario 'User deletes a user via user edit page' do

    click_on "Edit"

    click_on "Delete"

    expect(page).to have_content("User was successfully destroyed.")
    expect(page).to_not have_content("Joe Student")
    expect(page).to_not have_content("joestudent@email.com")

  end

  scenario 'User deletes a user via user show page' do

    click_on "Joe Student"

    expect(page).to have_content("First Name: Joe")
    expect(page).to have_content("Last Name: Student")
    expect(page).to have_content("Email: joestudent@email.com")

    click_on "Delete"

    expect(page).to have_content("User was successfully destroyed.")
    expect(page).to_not have_content("Joe Student")
    expect(page).to_not have_content("joestudent@email.com")

  end

  scenario 'User creates a new user without filling in form fields' do

    click_on "New User"

    click_on "Create User"

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email can't be blank")

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

  scenario 'User creates a new user with an invalid email address' do

    click_on "New User"

    fill_in "First Name", with: "Bob"
    fill_in "Last Name", with: "Smith"
    fill_in "Email", with: "bobsmithemail.com"

    click_on "Create User"

    expect(page).to have_content("New User")

  end

end

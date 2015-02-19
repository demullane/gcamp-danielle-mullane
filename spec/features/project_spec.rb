require 'rails_helper'

describe 'User can use the projects page succesfully (CRUD)' do

  before :each do
    Project.create(name: "Test Project")
    visit '/projects'
  end


  scenario 'User creates a new project' do

    click_on "New Project"

    fill_in "Name", with: "Test Project #2"

    click_on "Create Project"

    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Test Project #2")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")

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

    click_on "Test Project"

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

  #scenario 'User deletes a project via project edit page' do

    #click_on "Edit"

    #click_on "Delete"

    #expect(page).to have_content("Project was successfully destroyed.")
    #expect(page).to_not have_content("Test Project")

  #end

  scenario 'User deletes a project via project show page' do

    click_on "Test Project"

    expect(page).to have_content("Test Project")
    expect(page).to have_content("Edit")
    expect(page).to have_content("Delete")

    click_on "Delete"

    expect(page).to have_content("Project was successfully destroyed.")
    expect(page).to_not have_content("Test Project")

  end

  scenario 'User creates a new project with blank name field' do

    click_on "New Project"

    click_on "Create Project"

    expect(page).to have_content("Name can't be blank")

  end

  scenario 'User edits an existing project and saves with blank name field' do

    click_on "Edit"

    fill_in "Name", with: ""

    click_on "Update Project"

    expect(page).to have_content("Name can't be blank")

  end

end

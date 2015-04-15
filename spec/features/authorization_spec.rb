require 'rails_helper'

describe 'User cannot view unauthorized pages when not signed in' do

  scenario 'User who is not signed in cannot access /projects' do
    visit "/projects"

    expect(page).to have_content("Sign into gCamp!")
    expect(page).to have_content("You must sign in first.")
  end


  scenario 'User who is not signed in cannot access /users' do
    visit "/users"

    expect(page).to have_content("Sign into gCamp!")
    expect(page).to have_content("You must sign in first.")
  end

  scenario 'User who is not signed in cannot access a projects tasks page' do
    visit "/projects/20/tasks"

    expect(page).to have_content("Sign into gCamp!")
    expect(page).to have_content("You must sign in first.")
  end

  scenario 'User who is not signed in cannot access a projects memberships page' do
    visit "/projects/20/memberships"

    expect(page).to have_content("Sign into gCamp!")
    expect(page).to have_content("You must sign in first.")
  end

  scenario 'User who is not signed in cannot access a tasks comment page' do
    visit "/projects/20/tasks/20"

    expect(page).to have_content("Sign into gCamp!")
    expect(page).to have_content("You must sign in first.")
  end

end

require 'rails_helper'

describe 'User cannot view unathorized pages when not signed in' do

  scenario 'User who is not signed in cannot see Tasks pages' do

    visit "/tasks"

    expect(page).to have_content("You must sign in first.")
    expect(page).to have_content("Sign into gCamp!")
  end

  scenario 'User who is not signed in cannot see Projects pages' do

    visit "/projects"

    expect(page).to have_content("Sign into gCamp!")
    expect(page).to have_content("You must sign in first.")

  end

end

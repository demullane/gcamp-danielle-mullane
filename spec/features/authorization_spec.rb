require 'rails_helper'

describe 'User cannot view unathorized pages when not signed in' do

  before :each do
    visit '/'
  end

  scenario 'User who is not signed in cannot see Tasks pages' do

    click_on "Tasks"

    expect(page).to have_content("Sign into gCamp!")
  end

  scenario 'User who is not signed in cannot see Projects pages' do

    click_on "Projects"

    expect(page).to have_content("Sign into gCamp!")
  end

end

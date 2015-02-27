require 'rails_helper'

describe 'User can signup and is added to user table' do

  before :each do
    visit '/'

    click_on "Sign Up"

    fill_in "First Name", with: "Danielle"
    fill_in "Last Name", with: "Test"
    fill_in "Email", with: "dt@email.com"
    fill_in "Password", with: "pass"
    fill_in "Password Confirmation", with: "pass"
    click_button "Sign Up"
  end

  scenario 'User can signup' do

    expect(page).to have_content("Danielle Test")
    expect(page).to have_content("Your life, organized.")
    expect(page).to have_content("You have successfully signed up.")

  end

  scenario 'Once user is signedup user is added to user table' do

    click_on "Users"

    expect(page).to have_content("Users")
    expect(page).to have_content("dt@email.com")

  end

end

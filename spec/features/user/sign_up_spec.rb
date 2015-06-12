require_relative '../acceptance_helper'

feature 'User registration', %q{
  In order to be able to sign in
  As unregistered visitor of the site
  I want to be able to sing up in service
} do

  scenario 'Visitor signs up in the service' do
    visit new_user_registration_path

    user_attrs = attributes_for(:user)
    fill_in 'Email', with: user_attrs[:email]
    fill_in 'Password', with: user_attrs[:password]
    fill_in 'Password confirmation', with: user_attrs[:password_confirmation]
    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

end
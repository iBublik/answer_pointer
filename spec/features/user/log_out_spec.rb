require 'rails_helper'

feature 'User log out', %q{
  In order to finish work with service
  As authenticated user
  I want to be able to log out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to log out' do
    sign_in(user)

    click_on 'Log out'

    expect(page).to have_content('Signed out successfully.')
  end

end
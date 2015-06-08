require 'rails_helper'

feature 'Write answer', %q{
  In order to help someone to solve his problem
  As an authenticated user
  I want to be able to write answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'Authenticated user writes answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Add answer'
    fill_in 'Body', with: answer.body
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully added'
    expect(page).to have_content(answer.body)
  end

  scenario 'Non-authenticated user tries to write answer' do
    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user tries to add empty answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Add answer'
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end
end
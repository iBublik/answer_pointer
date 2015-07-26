require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answers from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Your question', with: question.body
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created'
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  end

  scenario 'Authenticated user tries to create question with invalid parameters' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    click_on 'Create'

    within '.question_title' do
      expect(page).to have_content "can't be blank"
    end
    within '.question_body' do
      expect(page).to have_content "can't be blank"
    end
  end

end

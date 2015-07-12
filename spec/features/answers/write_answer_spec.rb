require_relative '../acceptance_helper'

feature 'User answer', %q{
  In order to help someone to solve his problem
  As an authenticated user
  I want to be able to write answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'Authenticated user writes answer', js: true do
    sign_in(user)

    visit question_path(question)
    within '.new_answer' do
      fill_in 'Your answer', with: answer.body
      click_on 'Create'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer successfully added'
    expect(page).to have_content("#{question.answers.count} Answer")
    within 'section.answers' do
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'Non-authenticated user tries to write answer' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user tries to add invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'body can\'t be blank'
  end
end

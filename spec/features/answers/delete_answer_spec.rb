require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  In order to be able to remove answers
  As an authenticated user
  I want to be able to delete answers
} do

  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }
  given(:non_author) { create(:user) }

  scenario 'Author of the answer tries to delete answer', js: true do
    sign_in(author)

    visit question_path(question)
    within('section.answers') do
      click_on 'Delete'
    end

    expect(page).to have_content "#{question.answers.count} Answer"
    expect(page).to have_content 'Your answer was successfully deleted'
    expect(page).to_not have_content(answer.body)
  end

  scenario 'Non-author of the answer tries to delete answer' do
    sign_in(non_author)

    visit question_path(question)

    within('section.answers') do
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end

end
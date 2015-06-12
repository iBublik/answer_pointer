require_relative '../acceptance_helper'

feature 'Choose solution to question', %q{
  In order to mark answer which helps me to solve my problem
  As author of question
  I want to be able to make answer a solution
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:non_author) { create(:user) }


  scenario 'Non-authenticated user tries to mark question as solution' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Mark as solution'
    end
  end

  scenario 'Authenticated user tries to mark as solution answer to other user\'s question' do
    sign_in(non_author)

    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Mark as solution'
    end
  end

  describe 'Authenticated author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to mark as solution' do
      within '.answers' do
        expect(page).to have_content 'Mark as solution'
      end
    end

    scenario 'mark answer as solution', js: true do
      solution_answer = find("#answer-#{answers[1].id}")
      solution_answer.click_on('Mark as solution')

      expect(page).to have_selector('.answer.solution', count: 1)
      expect(solution_answer[:class]).to match(/solution/)
      expect(page).to have_selector('.answer:first-of-type', text: answers[1].body)
    end
  end

end
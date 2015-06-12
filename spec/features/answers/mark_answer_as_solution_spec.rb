require_relative '../acceptance_helper'

feature 'Choose solution to question', %q{
  In order to mark answer which helps me to solve my problem
  As author of question
  I want to be able to make answer a solution
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_pair(:answer, question: question) }
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
    given!(:solution) { create(:solution_answer, question: question) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to mark as solution' do
      within '.answers' do
        expect(page).to have_content 'Mark as solution'
      end
    end

    scenario 'sees existing solution in top if answers' do
      expect(page).to have_selector('.answer:first-of-type', text: solution.body)
    end

    scenario 'mark answer as solution', js: true do
      new_solution_css_id = "#answer-#{answers.last.id}"
      find(new_solution_css_id).click_on('Mark as solution')

      expect(page).to have_selector('.answer.solution', count: 1)
      expect(page).to have_selector("#{new_solution_css_id}.solution")
      expect(page).to_not have_selector("#answer-#{solution.id}.solution")
      expect(page).to have_selector('.answer:first-of-type', text: answers.last.body)
    end
  end

end
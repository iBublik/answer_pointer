require_relative '../acceptance_helper'

feature 'View question and it\'s answers', %q{
  In order to read full question description and possible solutions
  As an visitor of the site
  I want to be able to view question and it's answers
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given!(:solution) { create(:solution_answer, question: question) }

  before { visit question_path(question) }

  scenario 'Visitor of the site opens the page of the question' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_content "#{question.answers.count} Answers"
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Visitor of the site sees solution at the top of answers' do
    expect(page).to have_selector('.answer:first-of-type', text: solution.body)
  end

end
require 'rails_helper'

feature 'View question and it\'s answers', %q{
  In order to read full question description and possible solutions
  As an visitor of the site
  I want to be able to view question and it's answers
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Visitor of the site opens the page of the question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_content "#{answers.count} Answers"
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

end
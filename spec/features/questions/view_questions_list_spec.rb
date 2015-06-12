require_relative '../acceptance_helper'

feature 'View questions list', %q{
  In order to find existing analogue of my problem
  As an visitor of the site
  I want to be able to view list of all questions
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'Visitor opens the page of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
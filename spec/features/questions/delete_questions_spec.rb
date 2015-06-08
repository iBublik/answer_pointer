require 'rails_helper'

feature 'Delete question', %q{
  In order to be able to remove questions
  As an authenticated user
  I want to be able to delete questions
} do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:non_author) { create(:user) }

  scenario 'Author of the question tries to delete question from list of all questions' do
    sign_in(author)

    visit questions_path
    click_on 'Delete'

    expect(page).to have_content('Your question was successfully deleted')
  end

  scenario 'Author of the question tries to delete question from question page' do
    sign_in(author)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content('Your question was successfully deleted')
  end

  scenario 'Non-author of the question tries to delete question from list of all questions' do
    sign_in(non_author)

    visit questions_path

    expect(page).to_not have_content('Delete')
  end

  scenario 'Non-author of the question tries to delete question from question page' do
    sign_in(non_author)

    visit question_path(question)

    expect(page).to_not have_content('Delete')
  end

  scenario 'Non-authenticated user tries to delete question from list of all questions' do
    visit questions_path

    expect(page).to_not have_content('Delete')
  end

  scenario 'Non-authenticated user tries to delete question from question page' do
    visit question_path(question)

    expect(page).to_not have_content('Delete')
  end

end
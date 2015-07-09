require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix or update question
  As an author of the question
  I want to be able to edit question
} do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:non_author) { create(:user) }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated author' do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'sees the edit link' do
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his question', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'Edited title'
        fill_in 'Your question', with: 'Edited question'
        click_on 'Save'
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to_not have_content(question.title)
      expect(page).to_not have_content(question.body)
      expect(page).to have_content 'Edited title'
      expect(page).to have_content 'Edited question'
    end
  end

  scenario 'Authenticated user tries to edit other user\'s question' do
    sign_in non_author
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

end

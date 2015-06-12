require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix or update answer
  As an author of answer
  I want to be able to edit answer
} do

  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:non_author) { create(:user) }

  scenario 'Non-authenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link('Edit')
  end

  describe 'Authenticated author' do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'sees edit link' do
      within 'section.answers' do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'tries to edit his answer', js: true do
      click_on 'Edit'
      within 'section.answers' do
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to_not have_content(answer.body)
      expect(page).to have_content 'Edited answer'
    end
  end

  scenario 'Authenticated user tries to edit other user\'s answer' do
    sign_in non_author
    visit question_path(question)

    within 'section.answers' do
      expect(page).to_not have_content 'Edit'
    end
  end

end
require_relative '../acceptance_helper'

feature 'Remove question attachment', %q{
  In order to delete attachment file from question
  As an author of the question
  I want to be able to remove questions\'s attachments'
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attach) { create(:attachment, attachable: question) }
  given(:non_author) { create(:user) }

  describe 'Authenticated author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to remove attachment' do
      expect(page).to have_link 'Remove attachment'
    end

    scenario 'tries to delete his attachment',js: true do
      click_on 'Remove attachment'

      expect(page).to_not have_content(attach.file.identifier)
    end
  end

  scenario 'Authenticated user tries to remove file from other user\'s question' do
    sign_in(non_author)
    visit question_path(question)

    expect(page).to_not have_link 'Remove attachment'
  end

  scenario 'Non-authenticated user tries to remove file from question' do
    expect(page).to_not have_link 'Remove attachment'
  end

end
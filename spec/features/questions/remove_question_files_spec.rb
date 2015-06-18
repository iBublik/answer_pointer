require_relative '../acceptance_helper'

feature 'Remove question attachment', %q{
  In order to delete attachment file from question
  As an author of the question
  I want to be able to remove questions\'s attachments'
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachs) { create_pair(:attachment, attachable: question) }
  given(:non_author) { create(:user) }

  describe 'Authenticated author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to remove attachment' do
      attachs.each do |attach|
        expect(page).to have_link "delete-attach-#{attach.id}"
      end
    end

    scenario 'deletes single attachment', js: true do
      click_link "delete-attach-#{attachs.first.id}"

      within '.question' do
        expect(page).to_not have_selector("#attach-#{attachs.first.id}")
        expect(page).to have_content 'Attachments'
        expect(page).to have_content(attachs.last.file.identifier)
      end
    end

    scenario 'deletes all attachments', js: true do
      attachs.each do |attach|
        click_link "delete-attach-#{attach.id}"
        expect(page).to_not have_selector("#attach-#{attach.id}")
      end

      within '.question' do
        expect(page).to_not have_content 'Attachments'
      end
    end
  end

  scenario 'Authenticated user tries to remove file from other user\'s question' do
    sign_in(non_author)
    visit question_path(question)

    attachs.each do |attach|
      expect(page).to_not have_link "delete-attach-#{attach.id}"
    end
  end

  scenario 'Non-authenticated user tries to remove file from question' do
    attachs.each do |attach|
      expect(page).to_not have_link "delete-attach-#{attach.id}"
    end
  end

end
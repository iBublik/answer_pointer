require_relative '../acceptance_helper'

feature 'Remove answer attachment', %q{
  In order to delete attachment file from answer
  As an author of the answer
  I want to be able to remove answer\'s attachments'
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }
  given!(:attachs) { create_pair(:attachment, attachable: answer) }
  given(:non_author) { create(:user) }

  describe 'Authenticated author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to remove attachment' do
      within '.answers' do
        attachs.each do |attach|
          expect(page).to have_link "delete-attach-#{attach.id}"
        end
      end
    end

    scenario 'deletes single attachment', js: true do
      deleted_attach = attachs.first
      within '.answers' do
        click_link "delete-attach-#{deleted_attach.id}"

        expect(page).to_not have_link(deleted_attach.file.identifier,
                                      href: deleted_attach.file.url)
        expect(page).to have_content 'Attachments'
        expect(page).to have_link(attachs.last.file.identifier)
      end
    end

    scenario 'deletes all attachments', js: true do
      within '.answers' do
        attachs.each do |attach|
          click_link "delete-attach-#{attach.id}"
          expect(page).to_not have_link(attach.file.identifier, href: attach.file.url)
        end

        expect(page).to_not have_content 'Attachments'
      end
    end

    scenario 'removes attachment while editing answer', js: true do
      within '.answers' do
        click_on 'Edit'
      end

      deleted_attach = attachs.first
      within '.edit_answer' do
        within "#nested-fields-#{deleted_attach.id}" do
          click_on 'Remove attachment'
        end

        click_on 'Save'
      end

      within '.answers' do
        expect(page).to_not have_link(deleted_attach.file.identifier, href: deleted_attach.file.url)
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
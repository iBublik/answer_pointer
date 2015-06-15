require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test title'
    fill_in 'Your question', with: 'Test body'
  end

  given(:upload_files) { %w[spec_helper.rb rails_helper.rb] }

  scenario 'User adds several files when creates question', js: true do
    upload_files.each_with_index do |file, index|
      click_on 'Add attachment'
      all('input[type="file"]')[index].set("#{Rails.root}/spec/#{file}")
    end
    click_on 'Create Question'

    upload_files.each do |file|
      expect(page).to have_link "#{file}", "/uploads/attachment/file/1/#{file}"
    end
  end

  scenario 'User tries to add question with file, but didn\'t attach the file', js: true do
    click_on 'Add attachment'
    click_on 'Create Question'

    expect(page).to have_content 'Attachments file can\'t be blank'
  end

end
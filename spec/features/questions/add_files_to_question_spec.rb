require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:upload_files) { %w[spec_helper.rb rails_helper.rb] }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
  end

  scenario 'User adds several files when creates question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test title'
    fill_in 'Your question', with: 'Test body'
    upload_files.each_with_index do |file, index|
      click_on 'Add attachment'
      all('input[type="file"]')[index].set("#{Rails.root}/spec/#{file}")
    end
    click_on 'Create Question'

    upload_files.each do |file|
      expect(page).to have_link "#{file}"
    end
  end

  scenario 'User adds file while editing existing question', js: true do
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
    end

    within '.edit_question' do
      click_on 'Add attachment'
      attach_file 'File', "#{Rails.root}/spec/#{upload_files.first}"

      click_on 'Save'
    end

    within '.question' do
      expect(page).to have_link "#{upload_files.first}"
    end
  end
end
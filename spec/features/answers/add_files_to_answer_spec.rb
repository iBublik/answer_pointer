require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an question's answer
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:upload_files) { %w[spec_helper.rb rails_helper.rb] }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'Test body'
  end

  scenario 'User adds several files when creates answer', js: true do
    within '.new_answer' do
      upload_files.each_with_index do |file, index|
        click_on 'Add attachment'
        all('input[type="file"]')[index].set("#{Rails.root}/spec/#{file}")
      end
    end
    click_on 'Create Answer'

    within '.answers' do
      upload_files.each do |file|
        expect(page).to have_link "#{file}"
      end
    end
  end

  scenario 'User adds file while editing existing answer', js: true do
    within '.answers' do
      click_on 'Edit'
    end

    within '.edit_answer' do
      click_on 'Add attachment'
      attach_file 'File', "#{Rails.root}/spec/#{upload_files.first}"

      click_on 'Save'
    end

    within '.answers' do
      expect(page).to have_link "#{upload_files.first}"
    end
  end
end
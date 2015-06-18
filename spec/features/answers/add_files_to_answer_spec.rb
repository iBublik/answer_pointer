require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an question's answer
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'Test body'
  end

  given(:upload_files) { %w[spec_helper.rb rails_helper.rb] }

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
        expect(page).to have_link "#{file}", "/uploads/attachment/file/1/#{file}"
      end
    end
  end

end
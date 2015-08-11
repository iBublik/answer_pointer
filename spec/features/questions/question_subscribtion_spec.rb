require_relative '../acceptance_helper'

feature 'Question subscription', %q{
  In order to track new answers for interested question
  As an authenticated user
  I want to be able to subscribe to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  background(:each) do |scenario|
    sign_in(user) unless scenario.metadata[:skip_sign_in]
  end

  scenario 'Non-authenticated user tries to subscribe', skip_sign_in: true do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_content 'Subscribed'
  end

  scenario 'Authenticated user subscribes to question', js: true do
    visit question_path(question)
    click_on 'Subscribe'

    expect(page).to_not have_link 'Subscribe'
    expect(page).to have_content 'Subscribed'
  end

  scenario 'Author of question opens his question page' do
    visit question_path(user_question)

    expect(page).to_not have_link 'Subscribe'
    expect(page).to have_content 'Subscribed'
  end
end

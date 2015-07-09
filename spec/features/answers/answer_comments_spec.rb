require_relative '../acceptance_helper'

feature 'Question commenting', %q{
  In order to specify additional information
  As an authenticated user
  I want to be able to add comments
} do

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  #Is it possible to not hardcode commentable_type? How to create factory
  #for model with polymorphic association and ability to pass polymorhic owner as param?
  given!(:comments) { create_pair(:comment, commentable: answer, commentable_type: 'Answer') }

  scenario 'Non-authenticated user tries to add comment' do
    visit question_path(question)

    expect(page).to_not have_link 'Add comment'
  end

  scenario 'Visitor sees comment list' do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      comments.each do |comment|
        expect(page).to have_content(comment.body)
      end
    end
  end

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to add comment' do
      within "#answer-#{answer.id}" do
        expect(page).to have_link('Add comment')
      end
    end

    scenario 'adds a comment', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Add comment'
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Submit'

        expect(page).to have_content 'Test comment'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'cancels adding comment', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Add comment'
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Cancel'

        expect(page).to_not have_content 'Test comment'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

end

require_relative '../acceptance_helper'

feature 'Vote for questions', %q{
  In order to mark question as good or bad
  As authenticated user
  I want to be able to vote for or against question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:current_user_question) { create(:question, user: user) }

  scenario 'Non-authenticated user tries to vote for question' do
    visit question_path(question)

    expect(page).to_not have_link('Up')
    expect(page).to_not have_link('Down')
  end

  describe 'Authentcated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes against question', js: true do
      within '.question' do
        click_on 'Down'

        expect(page).to have_content('Rating: -1')
      end

      expect(page).to have_content('Your vote has been accepted')
    end

    scenario 'votes for question', js: true do
      within '.question' do
        click_on 'Up'

        expect(page).to have_content('Rating: 1')
      end

      expect(page).to have_content('Your vote has been accepted')
    end

    scenario 'tries to vote for question 2 times', js: true do
      within '.question' do
        click_on 'Up'

        expect(page).to_not have_link('Up')
        expect(page).to have_content('Voted up')
      end
    end

    scenario 'tries to vote against question 2 times', js: true do
      within '.question' do
        click_on 'Down'

        expect(page).to_not have_link('Down')
        expect(page).to have_content('Voted down')
      end
    end
  end

  describe 'User-voter' do
    given(:question_with_vote) { create(:question) }
    given!(:vote_up) { create(:vote_up, votable: question_with_vote, user: user) }

    background do
      sign_in(user)
      visit question_path(question_with_vote)
    end

    scenario 'sees cancel link' do
      within '.question' do
        expect(page).to have_link 'Cancel'
      end
    end

    scenario 'revotes for question', js: true do
      within '.question' do
        expect(page).to have_content 'Rating: 1'

        click_on 'Down'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario 'cancel his vote', js: true do
      within '.question' do
        expect(page).to have_content 'Rating: 1'

        click_on 'Cancel'
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_link 'Up'
        expect(page).to_not have_link 'Cancel'
      end

      expect(page).to have_content 'Your vote has been canceled'
    end
  end

  scenario 'Author of question tries to vote for it' do
    sign_in(user)
    visit question_path(current_user_question)

    within '.question' do
      expect(page).to_not have_link('Up')
      expect(page).to_not have_link('Down')
    end
  end

end
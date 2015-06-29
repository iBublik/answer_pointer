require_relative '../acceptance_helper'

feature 'Vote for answers', %q{
  In order to mark answer as good or bad
  As authenticated user
  I want to be able to vote for or against answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:current_user_answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user tries to vote for answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('Up')
      expect(page).to_not have_link('Down')
    end
  end

  describe 'Authentcated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes against answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Down'

        expect(page).to have_content('Rating: -1')
      end

      expect(page).to have_content('Your vote has been accepted')
    end

    scenario 'votes for answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Up'

        expect(page).to have_content('Rating: 1')
      end

      expect(page).to have_content('Your vote has been accepted')
    end

    scenario 'tries to vote for answer 2 times', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Up'

        expect(page).to_not have_link('Up')
        expect(page).to have_content('Voted up')
      end
    end

    scenario 'tries to vote against answer 2 times', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Down'

        expect(page).to_not have_link('Down')
        expect(page).to have_content('Voted down')
      end
    end
  end

  describe 'User-voter' do
    given(:answer_with_vote) { create(:answer, question: question) }
    given!(:vote_up) { create(:vote_up, votable: answer_with_vote, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees cancel link' do
      within "#answer-#{answer_with_vote.id}" do
        expect(page).to have_link 'Cancel'
      end
    end

    scenario 'revotes for answer', js: true do
      within "#answer-#{answer_with_vote.id}" do
        expect(page).to have_content 'Rating: 1'

        click_on 'Down'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario 'cancels his vote', js: true do
      within "#answer-#{answer_with_vote.id}" do
        expect(page).to have_content 'Rating: 1'

        click_on 'Cancel'
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_link 'Up'
        expect(page).to_not have_link 'Cancel'
      end

      expect(page).to have_content 'Your vote has been canceled'
    end
  end

  scenario 'Author of answer tries to vote for it' do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{current_user_answer.id}" do
      expect(page).to_not have_link('Up')
      expect(page).to_not have_link('Down')
    end
  end

end
require 'rails_helper'

shared_examples 'voting' do
  sign_in_user

  let(:votable_name) { described_class.controller_name.singularize.underscore.to_sym }
  let(:votable) { create(votable_name) }
  let(:current_user_votable) { create(votable_name, user: @user) }
  let(:votable_with_vote) { create(votable_name) }

  describe 'PATCH #vote_up' do
    context 'with correct conditions' do
      it 'saves vote in database' do
        expect { patch :vote_up, id: votable, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'changes the rating of votable' do
        expect { patch :vote_up, id: votable, format: :json }
            .to change { votable.reload.rating }.by(1)
      end

      it 'responds with success' do
        patch :vote_up, id: votable, format: :json
        expect(response).to be_success
      end
    end

    context 'by author of votable' do
      it 'does not save vote in database' do
        expect { patch :vote_up, id: current_user_votable, format: :json }
            .to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_up, id: current_user_votable, format: :json
        expect(response).to be_forbidden
      end
    end

    context 'multiple times' do
      before { patch :vote_up, id: votable, format: :json }

      it 'does not save second vote in database' do
        expect { patch :vote_up, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_up, id: votable, format: :json
        expect(response).to be_forbidden
      end
    end

    context 'already voted down' do
      before { votable_with_vote.make_vote(@user, -1) }

      it 'does not change number of votes in database' do
        expect { patch :vote_up, id: votable_with_vote, format: :json }
            .to_not change(Vote, :count)
      end

      it 'changes the rating of votable' do
        expect { patch :vote_up, id: votable_with_vote, format: :json }
            .to change { votable_with_vote.reload.rating }.by(2)
      end

      it 'responds with success' do
        patch :vote_up, id: votable_with_vote, format: :json
        expect(response).to be_success
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'with correct conditions' do
      it 'saves vote in database' do
        expect { patch :vote_down, id: votable, format: :json }
            .to change(votable.votes, :count).by(1)
      end

      it 'changes the rating of votable' do
        expect { patch :vote_down, id: votable, format: :json }
            .to change { votable.reload.rating }.by(-1)
      end

      it 'responds with success' do
        patch :vote_down, id: votable, format: :json
        expect(response).to be_success
      end
    end

    context 'by author of votable' do
      it 'does not save vote in database' do
        expect { patch :vote_down, id: current_user_votable, format: :json }
            .to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_down, id: current_user_votable, format: :json
        expect(response).to be_forbidden
      end
    end

    context 'multiple times' do
      before { patch :vote_down, id: votable, format: :json }

      it 'does not save second vote in database' do
        expect { patch :vote_down, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_down, id: votable, format: :json
        expect(response).to be_forbidden
      end
    end

    context 'already voted up' do
      before { votable_with_vote.make_vote(@user, 1) }

      it 'does not change number of votes in database' do
        expect { patch :vote_down, id: votable_with_vote, format: :json }
            .to_not change(Vote, :count)
      end

      it 'changes the rating of votable' do
        expect { patch :vote_down, id: votable_with_vote, format: :json }
            .to change { votable_with_vote.reload.rating }.by(-2)
      end

      it 'responds with success' do
        patch :vote_down, id: votable_with_vote, format: :json
        expect(response).to be_success
      end
    end
  end

  describe 'PATCH #vote_cancel' do
    context 'with user\'s vote' do
      before { votable_with_vote.make_vote(@user, 1) }

      it 'removes vote from database' do
        expect { patch :vote_cancel, id: votable_with_vote, format: :json }
          .to change(Vote, :count).by(-1)
      end

      it 'changes the rating of votable' do
        expect { patch :vote_cancel, id: votable_with_vote, format: :json }
          .to change { votable_with_vote.reload.rating }.by(-1)
      end

      it 'responds with success' do
        patch :vote_cancel, id: votable_with_vote, format: :json
        expect(response).to be_success
      end
    end

    context 'without user\'s vote' do
      it 'does not delete any vote from database' do
        expect { patch :vote_cancel, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_cancel, id: votable, format: :json
        expect(response).to be_forbidden
      end
    end

  end
end

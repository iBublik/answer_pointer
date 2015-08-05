shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:delete_all) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  describe '#make_vote' do
    it 'changes the rating of votable' do
      expect { votable.make_vote(user, 1) }.to change { votable.reload.rating }.by(1)
    end

    describe 'with existing vote of specified user' do
      before { votable.make_vote(user, 1) }

      it 'doesn\'t change the rating of votable if vote value stays the same' do
        expect { votable.make_vote(user, 1) }.to_not change { votable.reload.rating }
      end

      it 'change the rating of votable if new value differs from existing' do
        expect { votable.make_vote(user, -1) }.to change { votable.reload.rating }.by(-2)
      end
    end
  end

  describe '#cancel_vote' do
    it 'changes rating of votable if vote existed' do
      votable.make_vote(user, 1)
      expect { votable.cancel_vote(user) }.to change { votable.reload.rating }.by(-1)
    end

    it 'doesn\'t change rating of votable if vote didn\'t exist' do
      expect { votable.cancel_vote(user) }.to_not change { votable.reload.rating }
    end
  end

  describe '#voted_by?' do
    let(:other_user) { create(:user) }

    describe 'with existing vote of specified user' do
      before { votable.make_vote(user, 1) }

      it 'returns true if value of vote doesn\'t matter' do
        expect(votable.voted_by?(user)).to eq true
      end

      it 'returns true if value of vote matches specified value' do
        expect(votable.voted_by?(user, 1)).to eq true
      end

      it 'returns false if value of vote doesn\'t match specified value' do
        expect(votable.voted_by?(user, -1)).to eq false
      end
    end

    it 'returns false if votable is not voted by user' do
      votable.make_vote(other_user, 1)
      expect(votable.voted_by?(user)).to eq false
    end
  end

  describe '#user_vote' do
    let(:vote) { create(:vote_up, user: user, votable: votable) }

    it 'returns vote of user for specific votable if vote exists' do
      vote
      expect(votable.user_vote(user)).to eq vote
    end

    it 'returns nil if sought-for vote doesn\'t exist' do
      expect(votable.user_vote(user)).to be_nil
    end
  end
end

shared_examples_for 'voting' do
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

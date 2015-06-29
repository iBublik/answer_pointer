require 'rails_helper'

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

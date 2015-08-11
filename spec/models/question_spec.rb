require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_most(30_000) }
  it { should validate_length_of(:title).is_at_most(150) }

  it_should_behave_like 'attachable'
  it_should_behave_like 'votable'
  it_should_behave_like 'commentable'

  describe 'subscription' do
    let(:author) { create(:user) }
    subject { build(:question, user: author) }

    it 'should subscribe author to his question after create' do
      expect { subject.save! }.to change(author.subscriptions, :count).by(1)
    end

    it 'should not subscribe after update' do
      subject.save!
      expect(subject).to_not receive(:subscribe_author)
      subject.touch
    end
  end
end

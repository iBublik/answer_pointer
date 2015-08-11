require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:answer_to_user_question) { create(:answer, question: user_question) }
    let(:attachment) { create(:attachment) }
    let(:subscription) { build(:subscription) }
    let(:subscription_to_subscribed_question) do
      build(:subscription, question: create(:subscription, user: user).question)
    end

    %w(answer question).each do |resource|
      # resource of the user
      let("user_#{resource}".to_sym) { create(resource.to_sym, user: user) }
      # resource of other user
      let(resource.to_sym) { create(resource.to_sym) }
      let("user_attach_for_#{resource}".to_sym) do
        create(:attachment, attachable: eval("user_#{resource}"))
      end
      let("attach_for_#{resource}".to_sym) { create(:attachment, attachable: eval(resource)) }
      let("voted_up_#{resource}".to_sym) do
        create("#{resource}".to_sym).make_vote(user, 1)
      end
      let("voted_down_#{resource}".to_sym) do
        create("#{resource}".to_sym).make_vote(user, -1)
      end

      it { should be_able_to :crud, eval("user_#{resource}"), user: user }
      it { should_not be_able_to :crud, eval(resource), user: user }

      it { should be_able_to :manage, eval("user_attach_for_#{resource}") }
      it { should_not be_able_to :manage, eval(resource) }

      it { should be_able_to :vote_down, eval("voted_up_#{resource}") }
      it { should_not be_able_to :vote_up, eval("voted_up_#{resource}") }

      it { should be_able_to :vote_up, eval("voted_down_#{resource}") }
      it { should_not be_able_to :vote_down, eval("voted_down_#{resource}") }

      it { should be_able_to :vote_cancel, eval("voted_up_#{resource}") }
      it { should be_able_to :vote_cancel, eval("voted_down_#{resource}") }
      # Check user can't cancel vote to votable which he haven't vote
      it { should_not be_able_to :vote_cancel, eval(resource) }

      # Check user can't vote for his own votable
      it { should_not be_able_to :vote_up, eval("user_#{resource}") }
      it { should_not be_able_to :vote_down, eval("user_#{resource}") }
      it { should_not be_able_to :vote_cancel, eval("user_#{resource}") }
    end

    it { should be_able_to :mark_solution, answer_to_user_question }
    it { should_not be_able_to :mark_solution, answer }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Comment }

    it { should be_able_to :manage, :profile }

    it { should be_able_to :create, subscription }
    it { should_not be_able_to :create, subscription_to_subscribed_question }
  end
end

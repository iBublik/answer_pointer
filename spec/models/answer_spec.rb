require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_most(30_000) }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it_should_behave_like 'attachable'
  it_should_behave_like 'votable'
  it_should_behave_like 'commentable'

  describe '#mark_solution' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:solution) { create(:solution_answer, question: question) }

    before { answer.mark_solution }

    it 'sets the is_solutuion attribute to true for new solution and to false for old solution' do
      answer.reload
      solution.reload

      expect(answer.is_solution).to eq true
      expect(solution.is_solution).to eq false
    end

    it 'checks there is only one existing solution for question' do
      expect(question.answers.where(is_solution: true).count).to eq 1
    end
  end
end

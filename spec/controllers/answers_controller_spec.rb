require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it { should render_template :new }
  end

  describe 'POST #create' do
    let(:answer) { create(:answer) }

    context 'with valid parameters' do
      it 'should save new answer in database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
            .to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid params' do
      it 'does not save the answer' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }
            .to_not change(Answer, :count)
      end

      it 're-renders new question view' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

end

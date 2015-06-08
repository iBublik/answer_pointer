require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it { should render_template :new }
  end

  describe 'POST #create' do
    let(:answer) { create(:answer) }

    sign_in_user

    context 'with valid parameters' do
      it 'should save new answer in database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
            .to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end

      it 'should bind new answer to it\'s creator' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
            .to change(subject.current_user.answers, :count).by(1)
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

  describe 'DELETE #destroy' do
    sign_in_user

    context 'by author of answer' do
      let!(:current_user_answer) do
        create(:answer, user: subject.current_user, question: question)
      end

      it 'deletes answer' do
        expect { delete :destroy, id: current_user_answer }
            .to change(question.answers, :count).by(-1)
      end

      it 'redirects to question view' do
        delete :destroy, id: current_user_answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'by non-author' do
      let(:author) { create(:user) }
      let!(:another_user_answer) do
        create(:answer, user: author, question: question)
      end

      it 'does not delete question' do
        expect { delete :destroy, id: another_user_answer }
            .to_not change(Question, :count)
      end
    end
  end

end

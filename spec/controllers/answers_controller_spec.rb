require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:current_user_answer) { create(:answer, user: @user, question: question) }

  sign_in_user

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'should save new answer in database' do
        expect { post :create,
                 question_id: question.id,
                 answer: attributes_for(:answer),
                 format: :js
               }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end

      it 'should bind new answer to it\'s creator' do
        expect { post :create,
                 question_id: question.id,
                 answer: attributes_for(:answer),
                 format: :js
               }.to change(@user.answers, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'does not save the answer' do
        expect { post :create,
                 question_id: question.id,
                 answer: attributes_for(:invalid_answer),
                 format: :js
               }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'by author of answer' do
      before { current_user_answer }

      it 'deletes answer' do
        expect { delete :destroy, id: current_user_answer, format: :js }
          .to change(question.answers, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, id: current_user_answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'by non-author' do
      it 'does not delete question' do
        expect { delete :destroy, id: answer, format: :js }
          .to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the answer\'s question to @question' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    context 'by author of answer' do
      before { current_user_answer }

      it 'changes answer attributes' do
        patch :update, id: current_user_answer, answer: { body: 'Edited answer' }, format: :js
        current_user_answer.reload
        expect(current_user_answer.body).to eq 'Edited answer'
      end

      it 'renders update template' do
        patch :update, id: current_user_answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'by non-author of answer' do
      it 'does not change answer attributes' do
        old_answer = answer
        patch :update, id: answer, answer: { body: 'Edited answer' }, format: :js
        answer.reload
        expect(answer.body).to eq old_answer.body
      end
    end
  end

  describe 'PATCH #mark_solution' do
    let(:current_user_question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, question: current_user_question) }
    let!(:solution) { create(:solution_answer, question: current_user_question) }

    before { patch :mark_solution, id: answer, format: :js }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    context 'by author of question' do
      it 'changes is_solution attribute' do
        answer.reload
        solution.reload
        expect(answer.is_solution).to eq true
        expect(solution.is_solution).to eq false
      end

      it 'checks there is only one solution for answer' do
        expect(current_user_question.answers.where(is_solution: true).count).to eq 1
      end

      it 'renders mark solution template' do
        expect(response).to render_template :mark_solution
      end
    end

    context 'by non-author of question' do
      it 'does not change is_solution attribute' do
        old_answer = answer
        patch :mark_solution, id: answer, format: :js
        answer.reload
        expect(answer.is_solution).to eq old_answer.is_solution
      end
    end
  end

end

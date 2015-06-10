require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it { should render_template :index }
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to the question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it { should render_template :show }
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it { should render_template :new }
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it { should render_template :edit }
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'should save new question in database' do
        expect { post :create, question: attributes_for(:question) }
            .to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'should bind new question to it\'s creator' do
        expect { post :create, question: attributes_for(:question) }
            .to change(subject.current_user.questions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }
            .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'invalid atributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }

      it 'does not change question attributes' do
        old_question = question
        question.reload
        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end

      it { should render_template :edit }
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'by author of question' do
      let!(:user_question) { create(:question, user: subject.current_user) }

      it 'deletes question' do
        expect { delete :destroy, id: user_question }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'by non-author' do
      let(:author) { create(:user) }
      let!(:another_user_question) { create(:question, user: author) }

      it 'does not delete question' do
        expect { delete :destroy, id: another_user_question }
            .to_not change(Question, :count)
      end
    end
  end
end

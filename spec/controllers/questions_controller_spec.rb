require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:current_user_question) { create(:question, user: @user) }

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
            .to change(@user.questions, :count).by(1)
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
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes if logged user is author' do
        patch :update,
              id: current_user_question,
              question: { title: 'new title', body: 'new body' },
              format: :js
        current_user_question.reload
        expect(current_user_question.title).to eq 'new title'
        expect(current_user_question.body).to eq 'new body'
      end

      it 'does not change question attributes if logged user is not author' do
        old_question = question
        patch :update,
              id: question,
              question: { title: 'new title', body: 'new body' },
              format: :js
        question.reload
        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end

      it 'renders update template when user is author of question' do
        patch :update, id: current_user_question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end

      it 'responds with status forbidden when user is not author' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to be_forbidden
      end
    end

    context 'invalid atributes' do
      before do
        patch :update, id: current_user_question,
              question: { title: 'new title', body: nil }, format: :js
      end

      it 'does not change question attributes' do
        old_question = current_user_question
        current_user_question.reload
        expect(current_user_question.title).to eq old_question.title
        expect(current_user_question.body).to eq old_question.body
      end

      it { should render_template :update }
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before do
      question
      current_user_question
    end

    context 'by author of question' do
      it 'deletes question' do
        expect { delete :destroy, id: current_user_question }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, id: current_user_question
        expect(response).to redirect_to questions_path
      end
    end

    context 'by non-author' do
      it 'does not delete question' do
        expect { delete :destroy, id: question }
            .to_not change(Question, :count)
      end

      it 'redirects to root path' do
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end
  end

  it_behaves_like 'voting'
end

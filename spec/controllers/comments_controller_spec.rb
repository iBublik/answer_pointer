require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'for question with valid attributes' do
      it 'should save new comment in database' do
        expect { post :create,
                 question_id: question,
                 commentable: 'questions',
                 comment: attributes_for(:comment),
                 format: :js
               }.to change(question.comments, :count).by(1)
      end

      it 'should bind new comment to it\'s creator' do
        expect { post :create,
                 question_id: question,
                 commentable: 'questions',
                 comment: attributes_for(:comment),
                 format: :js
               }.to change(@user.comments, :count).by(1)
      end

      it 'should respond with success' do
        post :create, question_id: question, commentable: 'questions',
             comment: attributes_for(:comment), format: :js
        expect(response).to be_success
      end
    end

    context 'for question with invalid attributes' do
      it 'doesn\'t save comment in database' do
        expect { post :create,
                 question_id: question,
                 commentable: 'questions',
                 comment: attributes_for(:invalid_comment),
                 format: :js
               }.to_not change(Comment, :count)
      end

      it 'should respond with error' do
        post :create, question_id: question, commentable: 'questions',
             comment: attributes_for(:invalid_comment), format: :js
        expect(response).to be_unprocessable
      end
    end

    context 'for answer with valid attributes' do
      it 'should save new comment in database' do
        expect { post :create,
                 answer_id: answer,
                 commentable: 'answers',
                 comment: attributes_for(:comment),
                 format: :js
               }.to change(answer.comments, :count).by(1)
      end

      it 'should bind new comment to it\'s creator' do
        expect { post :create,
                 answer_id: answer,
                 commentable: 'answers',
                 comment: attributes_for(:comment),
                 format: :js
               }.to change(@user.comments, :count).by(1)
      end

      it 'should respond with success' do
        post :create, answer_id: answer, commentable: 'answers',
             comment: attributes_for(:comment), format: :js
        expect(response).to be_success
      end
    end

    context 'for answer with invalid attributes' do
      it 'doesn\'t save comment in database' do
        expect { post :create,
                 answer_id: answer,
                 commentable: 'answers',
                 comment: attributes_for(:invalid_comment),
                 format: :js
               }.to_not change(Comment, :count)
      end

      it 'should respond with error' do
        post :create, answer_id: answer, commentable: 'answers',
             comment: attributes_for(:invalid_comment), format: :js
        expect(response).to be_unprocessable
      end
    end
  end
end

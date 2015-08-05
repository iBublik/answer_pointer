require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    %w(question answer).each do |commentable|
      context "for #{commentable} with valid attributes" do
        let("#{commentable}_request".to_sym) do
          post :create, "#{commentable}_id".to_sym => eval(commentable),
                        commentable: commentable.pluralize,
                        comment: attributes_for(:comment),
                        format: :json
        end

        it 'should save new comment in database' do
          expect { eval("#{commentable}_request") }
            .to change(eval(commentable).comments, :count).by(1)
        end

        it 'should bind new comment to it\'s creator' do
          expect { eval("#{commentable}_request") }.to change(@user.comments, :count).by(1)
        end

        it 'should respond with success' do
          eval("#{commentable}_request")
          expect(response).to be_success
        end
      end

      context "for #{commentable} with invalid attributes" do
        let("#{commentable}_invalid_request".to_sym) do
          post :create, "#{commentable}_id".to_sym => eval(commentable),
                        commentable: commentable.pluralize,
                        comment: attributes_for(:invalid_comment),
                        format: :json
        end

        it 'doesn\'t save comment in database' do
          expect { eval("#{commentable}_invalid_request") }.to_not change(Comment, :count)
        end

        it 'should respond with error' do
          eval("#{commentable}_invalid_request")
          expect(response).to be_unprocessable
        end
      end
    end
  end
end

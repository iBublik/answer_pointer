require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user

  let(:attachable) { create(:question, user: @user) }
  let(:attach) { create(:attachment, attachable: attachable) }
  let(:other_user_attach) { create(:attachment) }

  describe 'DELETE #destroy' do
    before { attach }

    context 'by author of attachable' do
      it 'deletes attachment' do
        expect { delete :destroy, id: attach, format: :js }
            .to change(Attachment, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, id: attach, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'by non-author' do
      before { other_user_attach }

      it 'does not delete attachment' do
        expect { delete :destroy, id: other_user_attach, format: :js }
            .to_not change(Attachment, :count)
      end

      it 'responds with status forbidden' do
        delete :destroy, id: other_user_attach, format: :js
        expect(response).to be_forbidden
      end
    end
  end
end

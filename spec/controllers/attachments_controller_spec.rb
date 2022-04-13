require 'rails_helper'

describe AttachmentsController do
  let(:question)   { create(:question) }
  let(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    log_in_user
    before { attachment }

    it 'deleted attachment' do
      expect { delete :destroy, params: { id: attachment, format: :js } }.to change(question.attachments, :count).by(-1)
    end

    it 'render to destroy template' do
      delete :destroy, params: { id: attachment, format: :js}
      expect(response).to render_template :destroy
    end
  end
end

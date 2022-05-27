require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:subject) { create(:question) }
  it_behaves_like 'Votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }
end
  
require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:subject) { create(:question) }
  it_behaves_like 'Votable'
  it_behaves_like 'Attachable'

  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
  
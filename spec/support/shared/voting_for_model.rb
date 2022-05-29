shared_examples_for 'Votable' do 
  it { should have_many(:votes) }

  context 'voting' do
    let(:user) { create(:user) }

    it 'vote up' do 
      subject.vote_up(user)
      expect(subject.votes.size).to eq 1
      expect(subject.votes.sum(:value)).to eq 1 
    end

    it 'vote down' do 
      subject.vote_down(user)
      expect(subject.votes.size).to eq 1
      expect(subject.votes.sum(:value)).to eq -1
    end

    it 'revote, if voted up' do 
      subject.vote_up(user)
      subject.revote(user)
      expect(subject.reload.votes.size).to eq 0
      expect(subject.reload.votes.sum(:value)).to eq 0
    end

    it 'revote, if voted down' do 
      subject.vote_down(user)
      subject.revote(user)
      expect(subject.reload.votes.size).to eq 0
      expect(subject.reload.votes.sum(:value)).to eq 0
    end
  end
end

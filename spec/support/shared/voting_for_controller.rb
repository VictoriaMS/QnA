shared_examples_for 'Votable for controller' do 
  describe 'PATCH /voted_up' do 
    log_in_user

    it 'change votes count' do 
      expect{ patch :voted_up, params: { id: subject.id, format: :json } }.to change(subject.votes, :count).by(1)
    end

    it 'changes raiting for subject' do 
      patch :voted_up, params: { id: subject.id, format: :json }
      expect(subject.reload.raiting).to eq 1
    end
  end

  describe 'PATCH /voted_down' do 
    log_in_user

    it 'change votes count' do 
      expect{ patch :voted_down, params: { id: subject.id, format: :json } }.to change(subject.votes, :count).by(1)
    end

    it 'changes raiting for subject' do 
      patch :voted_down, params: { id: subject.id, format: :json }
      expect(subject.reload.raiting).to eq -1
    end
  end

  describe 'DELETE /revote' do 
    log_in_user
    let(:vote) { create(:vote, votable: subject, uer: @user) }

    it 'change votes count' do 
      subject.reload
      expect{ delete :revote, params: { id: subject.id, format: :json } }.to change(subject.votes, :count).by(0)
    end

    it 'changes raiting for subject' do 
      subject.reload
      delete :revote, params: { id: subject.id, format: :json }
      expect(subject.reload.raiting).to eq 0
    end
  end
end

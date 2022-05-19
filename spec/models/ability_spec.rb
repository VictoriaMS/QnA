require 'rails_helper'

RSpec.describe Ability, type: :model do 
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do 
    let!(:user) { nil } 
    
    it { should be_able_to :read, Question }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do 
    let!(:user) { create(:user, admin: true) }
    
    it { should be_able_to :manage, :all }
    it { should_not be_able_to :voted_up, create(:question) }
    it { should_not be_able_to :voted_down, create(:question) }
    it { should_not be_able_to :revote, create(:question) }

    it { should_not be_able_to :voted_up, create(:answer) }
    it { should_not be_able_to :voted_down, create(:answer) }
    it { should_not be_able_to :revote, create(:answer) }
  end

  describe 'for user' do 
    let(:user)       { create(:user) }
    let(:other_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'rights to manage questions' do 
      it { should be_able_to :create, Question }
    
      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other_user), user: user }
  
      it { should be_able_to :destroy, create(:question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }

      it { should be_able_to :voted_up, create(:question), user: user}
      it { should be_able_to :voted_down, create(:question), user: user}
      it { should be_able_to :revote, create(:question), user: user}

      it { should_not be_able_to :voted_up, create(:question, user: user), user: user}
      it { should_not be_able_to :voted_down, create(:question, user: user), user: user}
      it { should_not be_able_to :revote, create(:question, user: user), user: user}
    end

    context 'rights to manage answers' do 
      let(:question) { create(:question, user: user) }
      let(:other_question) { create(:question, user: create(:user)) }

      it { should be_able_to :create, Answer }
      
      it { should be_able_to :update, create(:answer, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

      it { should be_able_to :destroy, create(:answer, user: user), user: user }
      it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }  

      it { should be_able_to :voted_up, create(:answer), user: user}
      it { should be_able_to :voted_down, create(:answer), user: user}
      it { should be_able_to :revote, create(:answer), user: user}

      it { should_not be_able_to :voted_up, create(:answer, user: user), user: user}
      it { should_not be_able_to :voted_down, create(:answer, user: user), user: user}
      it { should_not be_able_to :revote, create(:answer, user: user), user: user}

      it { should be_able_to :update_best_answer, create(:answer, question: question), user: user }
      it { should_not be_able_to :update_best_answer, create(:answer, question: other_question), user: user }
    end
  end
end

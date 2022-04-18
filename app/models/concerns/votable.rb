module Votable 
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, inverse_of: :votable
  end

  def vote_up(user)
    votes.create(user_id: user.id, value: 1)
    update_raiting
  end

  def vote_down(user)
    votes.create(user_id: user.id, value: -1)
    update_raiting
  end 

  private
  
  def update_raiting
    self.raiting = votes.sum(:value)
    save 
  end 
end

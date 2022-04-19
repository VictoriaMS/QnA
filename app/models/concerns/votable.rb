module Votable 
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, inverse_of: :votable
  end

  def vote_up(user)
    unless user.author_of?(self)
      votes.create(user_id: user.id, value: 1)
      update_raiting
    end
  end

  def vote_down(user)
    unless user.author_of?(self)
      votes.create(user_id: user.id, value: -1)
      update_raiting
    end
  end 

  def revote(user) 
    votes.find_by(user_id: user.id).destroy
    update_raiting
  end 

  private
  
  def update_raiting
    self.raiting = votes.sum(:value)
    save 
  end 
end

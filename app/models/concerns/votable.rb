module Votable
  extend ActiveSupport::Concern

  def vote_up!
    self.voted_up += 1 
    self.save
  end

  def vote_down!
    self.voted_down += 1
    self.save
  end
end

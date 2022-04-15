module UpdateVotable 
  extend ActiveSupport::Concern

  def vote(resource, option)
    unless current_user.author_of?(resource)
      resource.send("vote_#{option}!")
      respond_to do |format|
        format.json { render json: resource }
      end
    end
  end
end

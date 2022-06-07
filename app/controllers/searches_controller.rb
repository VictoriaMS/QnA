class SearchesController < ApplicationController 
  def show
    @scope  = params[:scope].singularize.constantize unless params[:scope] == 'All'
    @result = ThinkingSphinx.search(params[:search], classes: [@scope])
  end
end

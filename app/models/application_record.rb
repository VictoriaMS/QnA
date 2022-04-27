class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def humanized_class
    self.class.to_s.underscore
  end
end

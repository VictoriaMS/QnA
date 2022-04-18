class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, optional: true

  validates :value, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
end

ThinkingSphinx::Index.define :answer, with: :active_record do 
  indexes body 
  indexes user.email, as: :author, sortable: true

  has user_id, created_at, updated_at 
  has question_id, created_at, updated_at
end

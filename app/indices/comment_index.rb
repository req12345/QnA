ThinkingSphinx::Index.define :comment, with: :active_record do
  #fields
  indexes body

  #attributes
  has user_id, commentable_type, commentable_id, created_at, updated_at
end

class Doc < BaseModel
  table do
    column path_index : String

    has_many replies : Reply
  end
end

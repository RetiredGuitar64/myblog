class Vote < BaseModel
  table do
    belongs_to user : User
    belongs_to reply : Reply?
    belongs_to doc : Doc?
    polymorphic target, associations: [:reply, :doc]

    column vote_type : String
  end
end

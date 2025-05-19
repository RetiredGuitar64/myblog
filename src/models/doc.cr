class Doc < BaseModel
  struct Votes
    include JSON::Serializable

    property 👍 : Int32 = 0
    property 👎 : Int32 = 0
    property ❤️ : Int32 = 0
  end

  table do
    column path_index : String

    has_many replies : Reply

    column votes : Doc::Votes, serialize: true
  end
end

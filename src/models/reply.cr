class Reply < BaseModel
  struct Preferences
    include JSON::Serializable

    property user_name : String
    property posted_at : Time
    property? path_for_doc : String?
    property? user_avatar : String? = nil
  end

  struct Votes
    include JSON::Serializable

    property 👍 : Int32 = 0
    property 👎 : Int32 = 0
    property 😄 : Int32 = 0
    property ❤️ : Int32 = 0
    property 🎉 : Int32 = 0
    property 😕 : Int32 = 0
    property 👀️ : Int32 = 0
  end

  table do
    belongs_to doc : Doc?
    belongs_to user : User

    column user_name : String?
    column content : String

    polymorphic target, associations: [:doc]
    column preferences : Reply::Preferences, serialize: true
    column votes : Reply::Votes, serialize: true
  end
end

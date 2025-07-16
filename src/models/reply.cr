class Reply < BaseModel
  struct Preferences
    include JSON::Serializable

    property? path_for_doc : String?
    property floor : Int32
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
    belongs_to reply : Reply?
    belongs_to user : User

    column content : String
    column user_name : String
    column user_avatar : String?
    column belongs_to_counter : Int32 = 0

    polymorphic target, associations: [:doc, :reply]
    column preferences : Reply::Preferences, serialize: true
    column votes : Reply::Votes, serialize: true
  end
end

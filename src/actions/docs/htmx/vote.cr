class Docs::Htmx::Vote < BrowserAction
  param reply_id : Int64
  param vote_type : String

  patch "/docs/htmx/vote" do
    reply = ReplyQuery.find(reply_id)
    h = Hash(String, Int32).from_json(reply.votes.to_json)

    q = VoteQuery.new.user_id(current_user.id).reply_id(reply.id)
    vote = q.vote_type(vote_type).first?

    if vote.nil?
      SaveVote.create(user_id: current_user.id, reply_id: reply.id, vote_type: vote_type) do |op|
        h[vote_type] += 1 if op.saved?
      end
    else
      DeleteVote.delete(vote) do |op|
        h[vote_type] -= 1 if op.deleted?
      end
    end

    voted_types = q.map &.vote_type

    UpdateReplyVotes.update(reply, votes: ::Reply::Votes.from_json(h.to_json)) do |op, updated_reply|
      if op.saved?
        component Shared::VoteButton, votes: h, reply_id: reply.id, current_user: current_user, voted_types: voted_types
      else
        head 400
      end
    end
  end
end

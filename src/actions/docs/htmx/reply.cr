module Docs
  module Htmx
    class Reply < DocAction
      param user_id : Int64
      param doc_id : Int64
      param content : String
      param doc_path : String

      # 回复评论按钮
      post "/docs/htmx/reply" do
        me = current_user
        return head 401 if me.nil?
        return head 401 if user_id != me.id
        return head 400 if content.blank?

        SaveReply.create(user_id: user_id, doc_id: doc_id, content: content) do |op, _saved_reply|
          if op.saved?
            component(
              Docs::FormWithReplies,
              formatter: formatter,
              pagination: replies_pagination(doc_path: doc_path),
              current_user: me,
              doc_path: doc_path,
              order_by: "desc"
            )
          else
            head 400
          end
        end
      end
    end

    class ReplyDelete < DocAction
      param user_id : Int64
      param reply_id : Int64

      delete "/docs/htmx/reply" do
        me = current_user
        return head 401 if me.nil?
        return head 401 if user_id != me.id

        reply = ReplyQuery.find(reply_id)

        ::DeleteReply.delete!(reply)

        head 200
      end
    end
  end
end

class Docs::RepliesMore < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?}
  needs page_number : Int32
  needs reply_path : String

  def render
    pagination[:replies].each do |reply|
      div class: "box f-col" do
        render_avatar_name_and_time(reply)

        hr style: "border: none; border-top: 1px solid darkgray;"

        markdown reply.content

        render_emoji_buttons(reply)
      end
    end

    render_more_link
  end

  private def render_avatar_name_and_time(reply)
    div class: "f-row justify-content:space-between", style: "" do
      div class: "f-row" do
        img src: reply.user_avatar || asset("svgs/crystal-lang-icon.svg"), style: "height:24px;width:24px;"
        span reply.user_name
      end

      span TimeInWords::Helpers(TimeInWords::I18n::ZH_CN).from(past_time: reply.created_at)
    end
  end

  private def render_emoji_buttons(reply : Reply)
    me = current_user
    voted_types = if me.nil?
                    [] of String
                  else
                    VoteQuery.new.user_id(me.id).reply_id(reply.id).map &.vote_type
                  end

    div class: "f-row", style: "margin-bottom: 0px;" do
      mount(
        Shared::VoteButton,
        votes: Hash(String, Int32).from_json(reply.votes.to_json),
        reply_id: reply.id,
        current_user: me,
        voted_types: voted_types
      )
    end
  end

  private def render_more_link
    div class: "f-row justify-content:center" do
      if pagination[:page].try &.next_page
        a(
          hx_get: "#{reply_path}?page=#{page_number + 1}",
          hx_target: "closest div",
          hx_swap: "outerHTML",
          hx_include: "#order_by"
        ) do
          text "加载更多评论"
          mount Shared::Spinner, text: "正在读取评论..."
        end
      else
        text "没有更多评论了"
      end
    end
  end
end

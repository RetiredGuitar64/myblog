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

        raw markdown(reply.content)

        render_emoji_buttons_and_delete_button(reply)
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

      div do
        span TimeInWords::Helpers(TimeInWords::I18n::ZH_CN).from(past_time: reply.created_at)
        raw <<-HEREDOC
<chip style="margin-left: 10px; border-color: #ccc;">#{reply.preferences.floor} 楼</chip>
HEREDOC
      end
    end
  end

  private def render_emoji_buttons_and_delete_button(reply : Reply)
    me = current_user
    voted_types = if me.nil?
                    [] of String
                  else
                    VoteQuery.new.user_id(me.id).reply_id(reply.id).map &.vote_type
                  end

    div class: "f-row justify-content:space-between", style: "margin-bottom: 0px;" do
      div do
        mount(
          Shared::VoteButton,
          votes: Hash(String, Int32).from_json(reply.votes.to_json),
          reply_id: reply.id,
          current_user: me,
          voted_types: voted_types
        )
      end

      if !(me = current_user).nil?
        a(
          "删除",
          class: "chip",
          hx_delete: Docs::Htmx::Reply::Delete.with(user_id: me.id, reply_id: reply.id).path,
          hx_target: "closest div.box",
          hx_swap: "outerHTML",
          hx_include: "[name='_csrf']",
          hx_confirm: "删除这条回复？"
        )
      end
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

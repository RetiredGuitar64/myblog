class Docs::RepliesMore < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?}
  needs page_number : Int32
  needs reply_path : String

  def render
    pagination[:replies].each do |reply|
      div class: "box f-col", id: fragment_id(reply) do
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
        a href: "##{fragment_id(reply)}" do
          span TimeInWords::Helpers(TimeInWords::I18n::ZH_CN).from(past_time: reply.created_at)
        end
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

      # wait 1s then put it into the next <output/>

      me = current_user

      if !me.nil?
        button(
          "查看回复",
          onclick: "document.getElementById('reply_dialog').showModal();",
          script: <<-'HEREDOC'
on click put '修改 #{user.email} 的密码' into the <#modal1 h5/>
then set @hx-put of <#modal1 a[hx-put]/> to '#{User::Htmx::Password.with(user_id).path}'
then js htmx.process(document.body) end
HEREDOC
        )

        if me.id == reply.user_id
          div do
            a(
              "编辑",
              class: "chip",
              style: "margin-right: 10px;",
              hx_get: Htmx::Docs::Reply::Edit.with(id: reply.id, user_id: me.id).path,
              hx_target: "div#form",
              hx_swap: "outerHTML",
              hx_include: "[name='_csrf']",
              script: "on click go to the top of the <#form/>"
              #             script: <<-'HEREDOC'
              # on click js
              #             event.preventDefault();
              #             const formElement = document.getElementById('form');
              #             formElement.scrollIntoView();
              # end
              # HEREDOC
            )

            a(
              "删除",
              class: "chip",
              hx_delete: Htmx::Docs::Reply::Delete.with(id: reply.id, user_id: me.id).path,
              hx_target: "closest div.box",
              hx_swap: "outerHTML swap:1s",
              hx_include: "[name='_csrf']",
              hx_confirm: "删除这条回复？"
            )
          end
        end
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

  private def fragment_id(reply)
    "doc_reply-#{reply.id}"
  end
end

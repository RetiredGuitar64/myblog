class Docs::RepliesMore < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?, url: String}
  needs page_number : Int32
  needs reply_id : Int64?

  def render
    div class: "mt-6" do # 1. 顶部增加间距
      pagination[:replies].each do |reply|
        id = reply.id

        article class: "bg-white/50 rounded-lg shadow p-4 mb-4 flex flex-col #{reply.reply_id ? "ml-8" : ""}", # 3. 背景半透明
          id: fragment_id(id) do
          render_avatar_name_and_time(reply)

          hr class: "border-0 border-t border-gray-300 my-3"

          div class: "reset-tw" do
            raw markdown(reply.content)
          end

          render_emoji_buttons_and_delete_button(reply)

          div class: "flex justify-center mt-3", id: "#{fragment_id(id)}-replies" do
            if reply.replies_counter > 0
              a(
                class: "text-blue-600 hover:text-blue-800 cursor-pointer transition-colors duration-200", # 2. & 4. 指针样式和过渡
                hx_get: "/htmx/replies/#{id}?page=1",
                hx_target: "##{fragment_id(id)}-replies",
                hx_swap: "outerHTML",
                hx_include: "previous input[name='order_by']",
              ) do
                text "加载评论，共 #{reply.replies_counter} 条回复"
                mount Shared::Spinner, text: "正在读取评论...", width: "10px"
              end
            end
          end
        end
      end
    end

    mount(
      Docs::RepliesMoreLink,
      pagination: pagination,
      page_number: page_number,
    )

    edit_dialog
  end

  private def render_avatar_name_and_time(reply)
    div class: "flex justify-between items-center" do
      div class: "flex items-center" do
        # 圆形头像容器
        div class: "relative h-6 w-6 mr-2" do
          # 圆形蒙版
          div class: "absolute inset-0 rounded-full overflow-hidden bg-gray-200" do
            # 头像图片
            img src: reply.user_avatar || asset("svgs/crystal-lang-icon.svg"),
              class: "w-full h-full object-cover"
          end
        end
        span reply.user_name, class: "text-gray-800"
      end

      if reply_id == reply.id
        div class: "text-green-600 opacity-0 animate-fade-out",
          data_script: "init transition my opacity to 0% over 3 seconds" do
          text "更新成功"
        end
      end

      div class: "flex items-center" do
        a href: "##{fragment_id(reply.id)}", class: "text-gray-500 text-sm" do
          span TimeInWords::Helpers(TimeInWords::I18n::ZH_CN).from(past_time: reply.created_at)
        end
        span class: "ml-2 px-2 py-1 text-xs border border-gray-300 rounded-full" do
          text "#{reply.preferences.floor}楼"
        end
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

    div class: "flex justify-between items-center mt-3" do
      div do
        mount(
          Shared::VoteButton,
          votes: Hash(String, Int32).from_json(reply.votes.to_json),
          reply_id: reply.id,
          current_user: me,
          voted_types: voted_types
        )
      end

      if !me.nil?
        base_button_classes = "px-3 py-1 mr-2 bg-gray-100 rounded-full cursor-pointer transition-all duration-200" # 2. & 4. 指针和过渡效果

        div class: "flex" do
          if reply.reply_id.nil?
            a("回复",
              class: "#{base_button_classes} hover:bg-gray-200", # 4. 平滑过渡
              hx_target: "div#reply_to_reply-form",
              hx_swap: "outerHTML",
              hx_include: "[name='_csrf']",
              hx_get: Htmx::Docs::Reply::New.with(id: reply.id, user_id: me.id).path,
              onclick: "
                const dialog = document.getElementById('edit_dialog');
                dialog.showModal();
                setTimeout(function() {
                  dialog.querySelector('textarea').focus();
                }, 500)
              "
            )
          end

          if me.id == reply.user_id
            a("编辑",
              class: "#{base_button_classes} hover:bg-gray-200", # 4. 平滑过渡
              hx_target: "div#reply_to_reply-form",
              hx_swap: "outerHTML",
              hx_include: "[name='_csrf']",
              hx_get: Htmx::Docs::Reply::Edit.with(id: reply.id, user_id: me.id).path,
              onclick: "
                const dialog = document.getElementById('edit_dialog');
                dialog.showModal();
                setTimeout(function() {
                  dialog.querySelector('textarea').focus();
                }, 500)
              "
            )

            if reply.replies_counter == 0
              a(
                "删除",
                class: "#{base_button_classes} bg-red-100 text-red-700 hover:bg-red-200", # 4. 平滑过渡
                hx_delete: Htmx::Docs::Reply::Delete.with(id: reply.id, user_id: me.id).path,
                hx_target: "closest article",
                hx_swap: "outerHTML swap:1s",
                hx_include: "[name='_csrf']",
                hx_confirm: "删除这条回复？"
              )
            end
          end
        end
      end
    end
  end

  private def fragment_id(reply_id)
    "doc_reply-#{reply_id}"
  end

  private def edit_dialog
    dialog(
      id: "edit_dialog",
      class: "fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 z-50 w-full max-w-3xl max-h-[90vh] bg-white rounded-lg shadow-xl p-0"
    ) do
      div id: "reply_to_reply-form" do
      end
    end
  end
end

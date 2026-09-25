class Forum::ShowPage < MainLayout
  include MarkdownFormatter

  needs topic : Topic
  needs comment_thread : CommentThread

  def page_title
    topic.title
  end

  def content
    div class: "#{page_container_classes} py-10" do
      article class: "mx-auto w-full max-w-[90ch]" do
        header class: "border-b border-gray-200 pb-5" do
          div class: "flex items-start gap-4" do
            h1 topic.title, class: "m-0 min-w-0 flex-1 text-3xl font-semibold tracking-tight text-gray-900"

            if current_user.try(&.id) == topic.user_id
              link "编辑", to: Forum::Edit.with(id: topic.id), class: "form-secondary shrink-0 px-3 py-1.5 text-sm"
            end
          end

          para class: "mt-3 mb-0 text-sm text-gray-500" do
            text "#{topic.user.name} 发布于 #{topic.created_at.to_s("%Y-%m-%d %H:%M")}"

            if (edited_at = topic.edited_at)
              text " · "
              span(
                "已编辑于 #{TimeInWords::Helpers(TimeInWords::I18n::ZH_CN).from(past_time: edited_at)}",
                title: edited_at.to_local.to_s("%Y-%m-%d %H:%M:%S")
              )
            end
          end
        end

        div class: "prose prose-neutral my-8 max-w-none text-base leading-7 text-gray-900" do
          raw user_markdown(topic.content)
        end

        section id: "form_with_comments", class: "mt-10" do
          mount(
            Comments::Form,
            current_user: current_user,
            comment_thread_id: comment_thread.id
          )

          show_comments_when_revealed(comment_thread.id)
        end
      end

      mount Comments::Dialog
    end
  end
end

class Docs::RepliesMoreLink < BaseComponent
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?, url: String}
  needs page_number : Int32

  def render
    div class: "f-row justify-content:center" do
      if pagination[:page].try &.next_page
        a(
          hx_get: "#{pagination[:url]}?page=#{page_number + 1}",
          hx_target: "closest div",
          hx_swap: "outerHTML",
          hx_include: "previous input[name='order_by']"
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

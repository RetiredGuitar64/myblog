class Docs::RepliesMoreLink < BaseComponent
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?, url: String}
  needs page_number : Int32

  def render
    div class: "flex justify-center items-center py-4" do  # 使用Tailwind的flex布局实现居中
      if pagination[:page].try &.next_page
        a(
          class: "text-blue-600 hover:text-blue-800 cursor-pointer transition-colors duration-200 flex items-center",  # 添加交互样式
          hx_get: "#{pagination[:url]}?page=#{page_number + 1}",
          hx_target: "closest div",
          hx_swap: "outerHTML",
          hx_include: "previous input[name='order_by']"
        ) do
          text "加载更多评论"
          span class: "ml-2" do  # 给spinner添加间距
            mount Shared::Spinner, text: "正在读取评论..."
          end
        end
      else
        div class: "text-gray-500" do  # 无更多评论的提示样式
          text "没有更多评论了"
        end
      end
    end
  end
end

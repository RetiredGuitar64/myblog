class Pager < BaseComponent
  include PageHelpers

  def render
    div class: "flex flex-row justify-between items-center pt-8" do
      item = PAGINATION_RELATION_MAPPING[current_path]?
      current_idx = PAGINATION_URLS.index(current_path)

      return unless current_idx

      prev_idx = [current_idx - 1, 0].max
      next_idx = [current_idx + 1, PAGINATION_URLS.size - 1].min
      prev_path = PAGINATION_URLS[prev_idx]
      next_path = PAGINATION_URLS[next_idx]

      if item
        # 上一页按钮
        div class: "flex items-center" do
          if prev_path == current_path
            div class: "flex items-center text-gray-400 cursor-default" do
              img src: asset("svgs/previous_page.svg"), alt: "previous_page", class: "h-6 mr-2 opacity-50"
              strong "没有上一页了"
            end
          else
            a href: prev_path, 
              class: "flex items-center bg-white/50 shadow-sm rounded-lg px-4 py-2 transition-all duration-200 hover:bg-white/70 hover:shadow-md" do
              img src: asset("svgs/previous_page.svg"), alt: "previous_page", class: "h-6 mr-2"
              strong PAGINATION_RELATION_MAPPING[prev_path][:title]
            end
          end
        end

        # 当前页标题
        h3 class: "text-lg font-medium" do
          text item[:title]
        end

        # 下一页按钮
        div class: "flex items-center" do
          if next_path == current_path
            div class: "flex items-center text-gray-400 cursor-default" do
              strong "没有下一页了"
              img src: asset("svgs/next_page.svg"), alt: "next_page", class: "h-6 ml-2 opacity-50"
            end
          else
            a href: next_path, 
              class: "flex items-center bg-white/50 shadow-sm rounded-lg px-4 py-2 transition-all duration-200 hover:bg-white/70 hover:shadow-md" do
              strong PAGINATION_RELATION_MAPPING[next_path][:title]
              img src: asset("svgs/next_page.svg"), alt: "next_page", class: "h-6 ml-2"
            end
          end
        end
      end
    end
  end
end
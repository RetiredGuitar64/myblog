class Docs::FormButtons < BaseComponent
  needs page_count : Int32 | Int64
  needs reply_path : String
  needs order_by : String
  needs hx_target : String

  def render
    div class: "flex items-center justify-between mt-2" do
      span "共 #{page_count} 条回复", class: "text-gray-600"

      div class: "flex items-center space-x-2" do
        render_order_buttons(reply_path)
      end
    end
  end

  private def render_order_buttons(reply_path : String)
    selected_classes = "bg-white/80 font-bold shadow-md"
    unselected_classes = "bg-gray-200 hover:bg-gray-300 cursor-pointer"

    [{"最早", "asc"}, {"最新", "desc"}].each do |title, order|
      a(
        title,
        class: "px-3 py-1 rounded-full transition #{order_by == order ? selected_classes : unselected_classes}",
        herf: "",
        hx_get: "#{reply_path}?order_by=#{order}",
        hx_target: hx_target,
        hx_swap: "outerHTML",
        hx_include: "next input[name='order_by']"
      )
    end

    input type: "hidden", name: "order_by", value: order_by
  end
end

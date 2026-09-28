class Search::Dialog < BaseComponent
  def render
    dialog(
      id: "doc_search_dialog",
      class: "mx-auto mt-[8vh] max-h-[calc(100vh_-_2rem)] w-[calc(100%_-_2rem)] max-w-xl rounded-xl border border-gray-300 bg-white p-0 shadow-xl sm:mt-[16vh]"
    ) do
      div class: "border-b border-gray-200 p-4" do
        div class: "flex items-center justify-between gap-3" do
          label "搜索文档", for: "search-input", class: "text-base font-semibold text-gray-900"
          button(
            "关闭",
            type: "button",
            class: "cursor-pointer text-sm text-gray-500 hover:text-gray-900",
            script: "on click close the closest <dialog/>"
          )
        end

        input(
          type: "search",
          name: "q",
          id: "search-input",
          placeholder: "至少 2 个汉字或 3 个英文字母",
          autocomplete: "off",
          autofocus: "true",
          class: "mt-3 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm outline-none focus:border-sky-600 focus:ring-2 focus:ring-sky-100",
          hx_get: Htmx::Search.path_without_query_params + "?scope=docs",
          hx_trigger: "input changed delay:500ms, search",
          hx_sync: "this:replace",
          hx_target: "#doc-search-results"
        )
      end

      div id: "doc-search-results", class: "max-h-[60vh] overflow-y-auto" do
        para "输入关键词开始搜索。", class: "m-0 px-4 py-6 text-center text-sm text-gray-500"
      end
    end
  end
end

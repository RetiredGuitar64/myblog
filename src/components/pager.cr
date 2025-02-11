class Pager < BaseComponent
  include PageHelpers

  def render
    footer do
      div class: "f-row justify-content:space-between", style: "padding-top: 3em;" do
        item = PAGINATION_RELATION_MAPPING[current_path]?
        current_idx = PAGINATION_URLS.index(current_path).not_nil!
        prev_idx = [current_idx - 1, 0].max
        next_idx = [current_idx + 1, PAGINATION_URLS.size - 1].min
        prev_path = PAGINATION_URLS[prev_idx]
        next_path = PAGINATION_URLS[next_idx]

        if item
          div class: "<h3>" do
            text "←"
            strong do
              if prev_path == current_path
                text "没有上一页了"
              else
                a PAGINATION_RELATION_MAPPING[prev_path][:name], href: prev_path
              end
            end
          end

          h3 do
            text item[:name]
          end

          div class: "<h3>" do
            text "→"
            strong do
              if next_path == current_path
                text "没有下一页了"
              else
                a PAGINATION_RELATION_MAPPING[next_path][:name], href: next_path
              end
            end
          end
        end
      end
    end
  end
end

class Pager < BaseComponent
  include PageHelpers

  def render
    div class: "f-row justify-content:space-between", style: "padding-top: 3em;" do
      item = PAGINATION_RELATION_MAPPING[current_path]?
      current_idx = PAGINATION_URLS.index(current_path)

      return unless current_idx

      prev_idx = [current_idx - 1, 0].max
      next_idx = [current_idx + 1, PAGINATION_URLS.size - 1].min
      prev_path = PAGINATION_URLS[prev_idx]
      next_path = PAGINATION_URLS[next_idx]

      if item
        div do
          img src: asset("svgs/previous_page.svg"), alt: "previous_page", style: "height: 24px; vertical-align: middle;"

          strong do
            if prev_path == current_path
              text "没有上一页了"
            else
              a PAGINATION_RELATION_MAPPING[prev_path][:title], href: prev_path
            end
          end
        end

        h3 do
          text item[:title]
        end

        div do
          img src: asset("svgs/next_page.svg"), alt: "next_page", style: "height: 24px; vertical-align: middle;"

          strong do
            if next_path == current_path
              text "没有下一页了"
            else
              a PAGINATION_RELATION_MAPPING[next_path][:title], href: next_path
            end
          end
        end
      end
    end
  end
end

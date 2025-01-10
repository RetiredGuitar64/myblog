class Pager < BaseComponent
  def render
    flex_direction = current_path == "/docs" ? "row-reverse" : "row"

    footer do
      div class: "f-row justify-content:space-between", style: "padding-top: 3em; flex-direction:#{flex_direction};" do
        if (prev_page = PageHelpers::PAGE_URL_MAPPING[current_path][:prev_page]?)
          div do
            text "←"
            strong do
              a prev_page.first, href: prev_page.last
            end
          end
        end

        if (next_page = PageHelpers::PAGE_URL_MAPPING[current_path][:next_page]?)
          div do
            text "→"
            strong do
              a next_page.first, href: next_page.last
            end
          end
        end
      end
    end
  end
end

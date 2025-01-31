class Pager < BaseComponent
  def render
    footer do
      div class: "f-row justify-content:space-between", style: "padding-top: 3em;" do
        if (path = PageHelpers::PAGE_URL_MAPPING[current_path]?)
          div class: "<h3>" do
            text "←"
            strong do
              if (prev_page = path[:prev_page]?)
                a prev_page.first, href: prev_page.last
              else
                text "没有上一页了"
              end
            end
          end

          h3 do
            text path[:name]
          end

          div class: "<h3>" do
            text "→"
            strong do
              if (next_page = path[:next_page]?)
                a next_page.first, href: next_page.last
              else
                text "没有下一页了"
              end
            end
          end
        end
      end
    end
  end
end

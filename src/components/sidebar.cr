class Sidebar < BaseComponent
  def render
    div "My App", class: "<h1>"

    nav do
      ul role: "list" do
        li do
          a "Home", href: "#", "aria-current": "page"
        end

        li do
          para do
            b "Tests"
          end

          ul role: "list", class: "margin" do
            li do
              a "Test 1", href: "#"
            end
            li do
              a "Lorem ipsum", href: "#"
            end
          end
        end

        li do
          strong do
            a "Back to home", class: "<button>", href: "/"
          end
        end
      end
    end
  end
end

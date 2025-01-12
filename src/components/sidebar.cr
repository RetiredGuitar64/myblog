class Sidebar < BaseComponent
  def render_child(ary)
    if !ary.empty?
      ul class: "margin" do
        ary.each do |child|
          li do
            a child.name, href: child.path

            render_child(child.child)
          end
        end
      end
    end
  end

  def render
    div "目录", class: "<h1>"

    nav do
      ul role: "list" do
        PageHelpers::SIDEBAR_LINKS.each do |k, v|
          if v.parent == "root"
            li do
              if current_path == v.path
                a v.name, href: k, class: "<button>"
              else
                a v.name, href: k
              end
            end

            render_child(v.child)
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

class Sidebar < BaseComponent
  def render_child(ary)
    if !ary.empty?
      ul class: "margin" do
        ary.each do |child|
          li do
            if current_path == child.path
              ins do
                a child.name, href: child.path
              end
            else
              a child.name, href: child.path
            end

            render_child(child.child)
          end
        end
      end
    end
  end

  def render
    div "目录", class: "<h1>"

    nav do
      ul role: "nested-list" do
        PageHelpers::SIDEBAR_LINKS.each do |k, v|
          if v.parent == "root"
            li do
              if current_path == v.path
                ins do
                  a v.name, href: k
                end
              else
                a v.name, href: k
              end
            end

            render_child(v.child)
          end
        end

        if (user = current_user)
          li do
            a user.email, href: "#"
          end
        end

        # li do
        #   strong do
        #     a "Back to home", class: "<button>", href: "/"
        #   end
        # end
      end
    end
  end
end

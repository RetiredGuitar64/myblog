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
            if (avatar = user.avatar)
              div class: "f-row align-items:center", style: "padding-right: 50px;
background-image:url(#{avatar});height:50px;width:300px;border-radius:20px;background-size: contain; background-repeat: no-repeat; background-position:left center;
color: white;text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
" do
                strong user.name, style: "margin-left: 55px;"
              end
            else
              text user.name
            end
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

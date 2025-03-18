class Sidebar < BaseComponent
  def render_child(ary, this_path)
    if !ary.empty?
      ul_attr = {class: "margin nested"}

      if ary.any? { |child| current_path.in? [this_path, child.path] }
        ul_attr = ul_attr.merge(style: "display: block;")
      end

      ul ul_attr do
        ary.each do |child|
          a_attr = {
            href: child.path,
          }

          if current_path == child.path
            a_attr = a_attr.merge(class: "active")
          end

          li do
            a child.name, a_attr
            render_child(child.child, child.path)
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
          _child = v.child
          li_attr = {} of Symbol => String

          if _child.empty?
            a_name = v.name
          else
            a_name = "#{v.name}         ➤"
          end

          a_attr = {
            href: k,
          }

          if current_path == v.path
            a_attr = a_attr.merge(class: "active")
          end

          if v.parent == "root"
            li li_attr do
              a a_name, a_attr
              render_child(_child, v.path)
            end
          end
        end

        if (user = current_user)
          li do
            if (avatar = user.avatar)
              div class: "f-row align-items:center", style: "padding-right: 50px;
background-image:url(#{avatar});height:24px;width:300px;border-radius:20px;background-size: contain; background-repeat: no-repeat; background-position:left center;
color: white;text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
" do
                strong user.name, style: "margin-left: 30px;"
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

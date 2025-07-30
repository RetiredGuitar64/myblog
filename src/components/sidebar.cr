class Sidebar < BaseComponent
  def render_child(ary, this_path)
    if !ary.empty?
      ul_class = "nested sidebar-nested"
      
      if ary.any? { |child| current_path.in? [this_path, child.path] }
        ul_class += " is-expanded"
      end

      ul class: ul_class do
        ary.each do |child|
          link_class = current_path == child.path ? "active sidebar-active" : ""
          
          li class: "sidebar-item" do
            a child.name, href: child.path, class: link_class
            render_child(child.child, child.path)
          end
        end
      end
    end
  end

  def render
    div class: "sidebar-title" do
      text "目录"
    end

    nav class: "sidebar-nav" do
      ul class: "sidebar-root", role: "nested-list" do
        PageHelpers::SIDEBAR_LINKS.each do |k, v|
          next unless v.parent == "root"
          
          _child = v.child
          link_text = _child.empty? ? v.name : "#{v.name} ➤"
          link_class = current_path == v.path ? "active sidebar-active" : ""

          li class: "sidebar-root-item" do
            a link_text, href: k, class: link_class
            render_child(_child, v.path)
          end
        end

        if (user = current_user)
          li class: "sidebar-user" do
            if (avatar = user.avatar)
              div class: "sidebar-user-profile",
                  style: "padding-right:50px;background-image:url(#{avatar});height:24px;width:300px;border-radius:20px;background-size:contain;background-repeat:no-repeat;background-position:left center;color:white;text-shadow:2px 2px 4px rgba(0,0,0,0.8)" do
                strong style: "margin-left:30px" do
                  text user.name
                end
              end
            else
              text user.name
            end
          end
        end
      end
    end
  end
end
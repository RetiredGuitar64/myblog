class Sidebar < BaseComponent
  def render_child(ary, this_path)
    if !ary.empty?
      ul_classes = "ml-4 mt-1 space-y-1"

      if ary.any? { |child| current_path.in? [this_path, child.path] }
        ul_classes += " block"
      else
        ul_classes += " hidden"
      end

      ul class: ul_classes do
        ary.each do |child|
          a_classes = "block px-3 py-2 rounded-md text-base font-medium transition-all duration-200 backdrop-blur-sm bg-white/20 hover:bg-white/40"

          if current_path == child.path
            a_classes += " bg-blue-200/50 text-blue-600 shadow-inner"
          else
            a_classes += " text-gray-800 hover:text-gray-900"
          end

          li do
            a child.name, href: child.path, class: a_classes
            render_child(child.child, child.path)
          end
        end
      end
    end
  end

  def render
    # 外层容器：固定定位、圆角、玻璃效果、滚动控制
    div class: "fixed left-6 top-22 w-64 h-[calc(100vh-6rem)] bg-white/10 backdrop-blur-md rounded-xl border border-white/20 shadow-xl overflow-y-auto hover:overflow-y-auto",
      style: "scrollbar-width: thin; scrollbar-color: rgba(255,255,255,0.3) transparent;" do
      div class: "p-4" do
        h1 "目录", class: "text-xl font-bold text-gray-800 mb-4"

        nav do
          ul class: "space-y-2" do
            PageHelpers::SIDEBAR_LINKS.each do |k, v|
              _child = v.child

              if _child.empty?
                a_name = v.name
              else
                a_name = "#{v.name} ➤"
              end

              a_classes = "block px-4 py-3 rounded-lg text-base font-medium transition-all duration-200 backdrop-blur-sm bg-white/20 hover:bg-white/40"

              if current_path == v.path
                a_classes += " bg-blue-200/50 text-blue-600 font-bold shadow-inner/10"
              else
                a_classes += " text-gray-800 hover:text-gray-900"
              end

              if v.parent == "root"
                li do
                  a a_name, href: k, class: a_classes
                  render_child(_child, v.path)
                end
              end
            end

            # 用户信息区域
            if (user = current_user)
              li class: "mt-6 pt-4 border-t border-white/30" do
                if (avatar = user.avatar)
                  div class: "flex items-center px-4 py-3 rounded-full bg-white/20 backdrop-blur-sm" do
                    # 圆形头像容器
                    div class: "relative w-8 h-8 mr-3" do
                      # 圆形蒙版
                      div class: "absolute inset-0 rounded-full overflow-hidden bg-gray-200" do
                        # 头像背景图
                        div class: "w-full h-full bg-cover bg-center",
                          style: "background-image: url('#{avatar}')"
                      end
                    end
                    strong user.name, class: "text-gray-800 font-medium"
                  end
                else
                  div class: "px-4 py-3 rounded-full bg-white/20 backdrop-blur-sm text-gray-800" do
                    text user.name
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

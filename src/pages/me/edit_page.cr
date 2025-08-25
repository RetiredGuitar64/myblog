class Me::EditPage < MainLayout
  needs op : UpdateUser

  def content
    div class: "flex justify-center items-start p-0" do
      div class: "bg-white/40 rounded-xl shadow-md px-15 py-6 border border-gray-200/50" do
        h2 class: "text-xl font-bold text-gray-800 text-center mb-6" do
          text "编辑我的信息"
        end

        form_for Me::Update do
          # 昵称
          div class: "mb-4" do
            label_for op.name, "昵称", class: "block text-sm font-medium text-gray-700 mb-1"
            text_input op.name, class: "w-full px-1 py-1 border border-gray-500 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          end

          # 头像
          div class: "mb-4" do
            label_for op.avatar, "头像（目前仅支持 http/https 链接）", class: "block text-sm font-medium text-gray-700 mb-1"
            text_input op.avatar, class: "w-full px-1 py-1 border border-gray-500 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            
            if (avatar = op.avatar.value)
              div class: "mt-2 flex justify-center" do
                # 圆形头像蒙版
                div class: "relative w-20 h-20" do
                  div class: "absolute inset-0 rounded-full overflow-hidden bg-gray-200" do
                    img src: avatar, class: "w-full h-full object-cover"
                  end
                end
              end
            end
          end

          # 密码
          div class: "mb-4" do
            label_for op.password, "密码", class: "block text-sm font-medium text-gray-700 mb-1"
            password_input op.password, auto_focus: true, class: "w-full px-1 py-1 border border-gray-500 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          end

          # 确认密码
          div class: "mb-6" do
            label_for op.password, "确认密码", class: "block text-sm font-medium text-gray-700 mb-1"
            password_input op.password_confirmation, class: "w-full px-1 py-1 border border-gray-500 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          end

          # 按钮
          div class: "flex justify-between items-center" do
            submit "保存", 
              class: "px-8 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors"
            
            # 修正链接语法
            a "返回", href: previous_url(fallback: Home::Index),
              class: "px-3 py-[6px] bg-gray-500 text-white rounded-full hover:bg-gray-600 transition-colors"
          end
        end
      end
    end
  end
end

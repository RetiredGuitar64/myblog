class Me::EditPage < MainLayout
  needs op : UpdateUser

  def content
    div class: "flex justify-center items-start p-0" do
      div class: "py-6 rounded-xl border shadow-md bg-white/40 px-15 border-gray-200/50" do
        h2 class: "mb-6 text-xl font-bold text-center text-gray-800" do
          text "编辑我的信息"
        end

        form_for Me::Update do
          # 昵称
          div class: "mb-4" do
            label_for op.name, "昵称", class: "block mb-1 text-sm font-medium text-gray-700"
            text_input op.name, class: "py-1 px-1 w-full rounded-lg border border-gray-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
          end

          # 头像
          div class: "mb-4" do
            label_for op.avatar, "头像（目前仅支持 http/https 链接）", class: "block mb-1 text-sm font-medium text-gray-700"
            text_input op.avatar, class: "py-1 px-1 w-full rounded-lg border border-gray-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
            
            if (avatar = op.avatar.value)
              div class: "flex justify-center mt-2" do
                # 圆形头像蒙版
                div class: "relative w-20 h-20" do
                  div class: "overflow-hidden absolute inset-0 bg-gray-200 rounded-full" do
                    img src: avatar, class: "object-cover w-full h-full"
                  end
                end
              end
            end
          end

          # 密码
          div class: "mb-4" do
            label_for op.password, "密码", class: "block mb-1 text-sm font-medium text-gray-700"
            password_input op.password, auto_focus: true, class: "py-1 px-1 w-full rounded-lg border border-gray-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
          end

          # 确认密码
          div class: "mb-6" do
            label_for op.password, "确认密码", class: "block mb-1 text-sm font-medium text-gray-700"
            password_input op.password_confirmation, class: "py-1 px-1 w-full rounded-lg border border-gray-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
          end

          # 按钮
          div class: "flex justify-between items-center" do
            submit "保存", 
              class: "py-2 px-8 text-white bg-blue-500 rounded-full transition-colors hover:bg-blue-600"
            
            # 修正链接语法
            a "返回", href: previous_url(fallback: Home::Index),
              class: "px-3 text-white bg-gray-500 rounded-full transition-colors hover:bg-gray-600 py-[6px]"
          end
        end
      end
    end
  end
end

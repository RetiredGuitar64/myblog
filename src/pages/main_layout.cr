abstract class MainLayout
  include Lucky::HTMLPage
  include PageHelpers

  needs current_user : User?

  abstract def content

  def page_title
    "首页"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body class: "min-h-screen bg-gradient-to-br from-gray-200 via-blue-300 to-purple-400" do
        div class: "flex flex-col min-h-screen items-center" do
          # 导航栏
          mount Navbar, current_user: current_user

          # 主要内容区域（自动适应内容大小）
          main class: "w-auto mx-auto my-8" do
            div class: "bg-white/30 rounded-3xl shadow-lg p-8 flex flex-col items-center" do
              content
            end
          end

          # 页脚区域（自动适应内容大小）
          footer class: "mt-auto w-full" do
            div class: "container mx-auto px-4 pb-8 flex justify-center" do
              div class: "backdrop-blur-2xl bg-white/20 rounded-2xl shadow-sm p-6 inline-flex flex-col items-center" do
                mount Footer, current_user: current_user
              end
            end
          end
        end

        # 公共组件
        mount Shared::Common, page_title: page_title
      end
    end
  end
end
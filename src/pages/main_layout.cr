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

      body class: "min-h-screen bg-gradient-to-br from-lime-100 to-purple-400 via-sky-300" do
        div class: "flex flex-col items-center min-h-screen" do
          # 导航栏
          mount Navbar, current_user: current_user

          # 主要内容区域（自动适应内容大小）
          main class: "my-8 mx-auto w-auto" do
            div class: "flex flex-col items-center p-8 rounded-3xl shadow-lg bg-white/30" do
              content
            end
          end

          # 页脚区域（自动适应内容大小）
          footer class: "mt-auto w-full" do
            div class: "container flex justify-center px-4 pb-8 mx-auto" do
              div class: "inline-flex flex-col items-center p-4 rounded-full shadow-sm backdrop-blur-2xl bg-white/20" do
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

class Navbar < BaseComponent
  def render
    header class: "sticky top-0 z-50 py-2 px-4 w-full rounded-b-lg shadow-lg bg-white/20 backdrop-blur-sm" do
      div class: "flex flex-col justify-between items-center md:flex-row" do
        # Logo and brand on the left
        div class: "flex items-center mb-2 md:mb-0" do
          a href: "/", class: "flex items-center" do
            img src: asset("svgs/crystal.svg"), alt: "crystal-china", class: "w-24 md:w-32"
            span "China", class: "ml-2 text-lg font-medium text-black uppercase"
          end
        end

        # Navigation items on the right
        nav class: "contents" do
          ul class: "flex flex-wrap gap-2 justify-center md:gap-4" do
            li do
              if current_path.starts_with?("/docs")
                tag "search" do
                  button "搜索博客", 
                    onclick: "document.getElementById('doc_search_dialog').showModal();",
                    class: "py-1 px-3 rounded-full border border-gray-300 shadow-sm transition-colors hover:bg-gray-100 active:bg-gray-200"
                end
              else
                a "打开博客(Open Blog)", 
                  href: "/docs/index",
                  class: "block py-1 px-3 rounded-full border border-gray-300 shadow-sm transition-colors hover:bg-gray-100 active:bg-gray-200"
              end
            end

            li do
              a "本站源码", 
                href: "https://github.com/RetiredGuitar64/myblog",
                class: "block py-1 px-3 rounded-full border border-gray-300 shadow-sm transition-colors hover:bg-gray-100 active:bg-gray-200"
            end

            me = current_user
            if me
              li do
                link(
                  "登出",
                  to: SignIns::Delete,
                  flow_id: "sign-out-button",
                  hx_target: "body",
                  hx_push_url: "true",
                  hx_delete: SignIns::Delete.path,
                  hx_include: "[name='_csrf']",
                  class: "block py-1 px-3 rounded-full border border-gray-300 shadow-sm transition-colors hover:bg-gray-100 active:bg-gray-200"
                )
              end

              li do
                link me.email, 
                  to: Me::Edit,
                  class: "block py-1 px-3 rounded-full border border-gray-300 shadow-sm transition-colors hover:bg-gray-100 active:bg-gray-200"
              end
            else
              li do
                link "注册", 
                  to: SignUps::New,
                  class: "block py-1 px-3 rounded-full border border-gray-300 shadow-sm transition-colors hover:bg-gray-100 active:bg-gray-200"
              end

              li do
                link "登录", 
                  to: SignIns::New,
                  class: "block py-1 px-3 rounded-full border border-gray-300 shadow-sm transition-colors hover:bg-gray-100 active:bg-gray-200"
              end
            end
          end
        end
      end

      # Flash messages
      div class: "flex justify-end mt-2" do
        mount Shared::FlashMessages, context.flash
      end
    end
  end
end
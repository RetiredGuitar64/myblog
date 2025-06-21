class Navbar < BaseComponent
  def render
    header class: "navbar", style: "margin-bottom: 2px; margin-top: 0px; width: 100%;" do
      div do
        a href: "/", class: "f-row align-items:center" do
          img src: asset("svgs/crystal.svg"), alt: "crystal-china", style: "width: 150px;"
          span "China", class: "allcaps", style: "color: black;"
        end
      end

      nav class: "contents" do
        ul role: "list" do
          li do
            link "首页", to: Home::Index
          end

          li do
            if current_path.starts_with?("/docs")
              tag "search" do
                strong do
                  button "搜索文档", onclick: "document.querySelectorAll('dialog')[0].showModal();"
                end
              end
            else
              link "学习文档", to: Docs::Index
            end
          end

          li do
            a "本站源码", href: "https://github.com/crystal-china/website"
          end

          me = current_user
          if me
            li do
              link(
                "退出",
                to: SignIns::Delete,
                flow_id: "sign-out-button",
                hx_target: "body",
                hx_push_url: "true",
                hx_delete: SignIns::Delete.path,
                hx_include: "[name='_csrf']",
              )
            end

            li do
              # a me.email, href: link
              link me.email, to: Me::Edit
            end
          else
            li do
              link "注册", to: SignUps::New
            end

            li do
              link "登录", to: SignIns::New
            end
          end
        end
      end
    end

    div class: "f-row justify-content:end" do
      mount Shared::FlashMessages, context.flash
    end
  end
end

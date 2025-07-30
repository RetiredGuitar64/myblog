class Navbar < BaseComponent
  def render
    header class: "navbar-container" do # 移除内联样式，改用class
      div class: "navbar-brand" do
        a href: "/", class: "navbar-logo" do
          img src: asset("svgs/crystal.svg"), alt: "crystal-china", class: "navbar-logo-img"
          span "China", class: "navbar-logo-text allcaps"
        end
      end

      nav class: "navbar-menu" do # 修改class
        ul class: "navbar-links", role: "list" do # 修改class
          li class: "navbar-item" do # 添加class
            if current_path.starts_with?("/docs")
              tag "search", class: "navbar-search" do
                strong do
                  button "搜索博客", 
                    class: "navbar-search-button",
                    onclick: "document.getElementById('doc_search_dialog').showModal();"
                end
              end
            else
              a "打开博客(Open Blog)", href: "/docs/index", class: "navbar-link"
            end
          end

          li class: "navbar-item" do
            a "本站源码", 
              href: "https://github.com/RetiredGuitar64/myblog",
              class: "navbar-link",
              target: "_blank"
          end

          me = current_user
          if me
            li class: "navbar-item" do
              link(
                "登出",
                to: SignIns::Delete,
                class: "navbar-link",
                flow_id: "sign-out-button",
                hx_target: "body",
                hx_push_url: "true",
                hx_delete: SignIns::Delete.path,
                hx_include: "[name='_csrf']",
              )
            end

            li class: "navbar-item" do
              link me.email, 
                to: Me::Edit,
                class: "navbar-user-email"
            end
          else
            li class: "navbar-item" do
              link "注册", 
                to: SignUps::New,
                class: "navbar-link"
            end

            li class: "navbar-item" do
              link "登录", 
                to: SignIns::New,
                class: "navbar-link"
            end
          end
        end
      end
    end

    div class: "flash-messages-container" do # 修改class
      mount Shared::FlashMessages, context.flash
    end
  end
end
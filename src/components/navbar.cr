class Navbar < BaseComponent
  def render
    div do
      a href: "/", class: "f-row justify-content:end align-items:center" do
        raw <<-'HEREDOC'
<canvas height="30" id="logo-canvas" style="cursor:move" width="130"></canvas>
HEREDOC
        img src: "#{asset_host}/svgs/crystal.svg", alt: "crystal-china"

        span "China", class: "allcaps", style: "color: black;"
      end
    end

    # div class: "brand-logo" do
    # end

    nav class: "contents" do
      tag "search" do
        strong do
          button "搜索文档", onclick: "document.querySelectorAll('dialog')[0].showModal();"
        end
      end

      ul role: "list" do
        li do
          link "文档", to: Docs::Index
        end

        li do
          a "Github", href: "https://github.com/orgs/crystal-china/repositories"
        end

        if !current_user
          li do
            link "注册", to: SignUps::New
          end
        end

        if current_user
          li do
            link(
              "退出",
              to: SignIns::Delete,
              hx_target: "body",
              hx_push_url: "true",
              hx_delete: SignIns::Delete.path,
              hx_include: "[name='_csrf']"
            )
          end
        else
          li do
            link "登录", to: SignIns::New
          end
        end
      end
    end
  end
end

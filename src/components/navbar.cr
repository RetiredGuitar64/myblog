class Navbar < BaseComponent
  def render
    div do
      a href: "/", class: "f-row justify-content:end align-items:center" do
        raw <<-'HEREDOC'
    <canvas height="30" id="logo-canvas" style="cursor:move" width="130"></canvas>
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 230 42">
      <path d="m27.93 34.73.64 5.45a42 42 0 0 1-12.29 1.51q-9 0-12.63-4.64T0 21Q0 9.58 3.65 4.95T16.28.31a45.27 45.27 0 0 1 11.48 1.28l-.69 5.51q-5-.4-10.78-.41-5 0-6.81 3T7.65 21q0 8.23 1.82 11.27t6.81 3a91.36 91.36 0 0 0 11.65-.54ZM64.79 41h-7.71l-3.19-12.4a4.51 4.51 0 0 0-4.63-3.6l-7.18-.06V41h-7.2V1Q40 .48 49.43.49 57 .49 60.18 3t3.16 9.19q0 4.63-1.74 7.1t-5.74 3v.29a7 7 0 0 1 3.25 1.85 7.82 7.82 0 0 1 2.09 4.06ZM42.07 19h7.18q3.88-.06 5.3-1.39t1.42-5Q56 9 54.56 7.73t-5.3-1.28h-7.19Zm44.74 8.46V41h-7.25V27.37L66.41 1h7.65l7.3 15.53q.4.93 1.62 4.81h.46q1.22-3.88 1.62-4.81L92.37 1h7.53Zm32-2.32-8.06-2.55a11.15 11.15 0 0 1-6.2-4.2 13.22 13.22 0 0 1-1.86-7.39q0-6.55 3-8.64T116.42.31A51.36 51.36 0 0 1 129 1.65l-.46 5.16q-6.6-.23-11.88-.23-4 0-5.33.78T110 11.15a5.07 5.07 0 0 0 1 3.51 8.38 8.38 0 0 0 3.51 1.82l7.71 2.38q4.58 1.45 6.4 4.26a13.37 13.37 0 0 1 1.83 7.39q0 6.61-3.13 8.9t-11.07 2.29a66.11 66.11 0 0 1-13-1.27l.46-5.33q10.14.23 12.69.23 4 0 5.33-.93t1.27-3.95a5.31 5.31 0 0 0-.9-3.54 7.64 7.64 0 0 0-3.3-1.74ZM166 7.21h-12.32V41h-7.3V7.21h-12.23V1H166Zm23.76 22.49h-14.81l-3.3 11.3h-7.42l12-38.07a2.43 2.43 0 0 1 2.6-1.93h7.07a2.43 2.43 0 0 1 2.61 1.91l12 38.07h-7.42Zm-1.74-6L184 9.93q-.81-3.13-.87-3.42h-1.56l-.93 3.42-4 13.79ZM212.38 1v30.66a3.52 3.52 0 0 0 .75 2.58 3.83 3.83 0 0 0 2.66.72h13.91l.29 5.62q-5.68.52-15.88.52-9 0-9-8.29V1Z"></path>
    </svg>
    HEREDOC

        span class: "allcaps" do
          text "China"
        end
      end

      #   raw <<-'HEREDOC'
      #     <svg height="30" viewBox="0 0 207.90188 207.90188" width="50" xmlns="http://www.w3.org/2000/svg">
      #       <circle cx="103.95094" cy="103.95094" fill="#F2F4F6" fill-opacity=".965067" r="103.66196" stroke="#fffffe" stroke-linecap="round" stroke-width=".377953"/>
      #       <path d="m172.40984 122.47634-50 49.9c-.2.2-.5.3-.7.2l-68.300004-18.3c-.3-.1-.5-.3-.5-.5l-18.4-68.200003c-.1-.3 0-.5.2-.7l50-49.899999c.2-.2.5-.3.7-.2l68.300004 18.299999c.3.1.5.3.5.5l18.3 68.200003c.2.3.1.5-.1.7zm-67-54.300003-67.100004 17.9c-.1 0-.2.2-.1.3l49.1 49.000003c.1.1.3.1.3-.1l18.000004-67.000003c.1 0-.1-.2-.2-.1z"/>
      #     </svg>
      # HEREDOC
    end

    # div class: "brand-logo" do
    # end

    nav class: "contents" do
      # tag "search" do
      #   strong do
      #     button "Search", onclick: "document.querySelectorAll('dialog')[0].showModal();"
      #   end
      # end

      div id: "docsearch" do
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
              "登出",
              to: SignIns::Delete,
              hx_target: "body",
              hx_push_url: "true",
              hx_delete: SignIns::Delete.path,
              hx_include: "next input"
            )
            input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
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

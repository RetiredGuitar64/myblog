class Footer < BaseComponent
  def render
    section class: "flex flex-col gap-6 justify-center items-center text-sm text-gray-800 sm:flex-row" do
      # 文本信息组
      div class: "flex flex-wrap gap-5 justify-center items-center" do
        span class: "flex items-center ml-5 h-6 font-medium transition-colors hover:text-black" do
          text "Crystal China"
        end

        a "spider.yuxuan@gmail.com", 
          href: "mailto:spider.yuxuan@gmail.com",
          class: "flex items-center h-6 underline transition-all hover:text-black underline-offset-4 decoration-gray-300 hover:decoration-gray-500"

        span(
          class: "flex items-center py-0.5 px-3 h-6 bg-gray-300 rounded-full transition-colors hover:bg-gray-200",
          hx_trigger: "load,every 2m",
          hx_patch: Htmx::OnlineUsers.with(user_id: current_user.try(&.id)).path,
          hx_include: "[name='_csrf']"
        ) do
          span class: "inline-flex gap-1 items-center" do
            tag "svg", width: 8, height: 8, viewBox: "0 0 8 8", class: "text-green-500 fill-current" do
              tag "circle", cx: "4", cy: "4", r: "4"
            end
            text "在线 #{ONLINE_USER_COUNTER.keys.size} 人 • 游客 #{ONLINE_IP_COUNTER.keys.size} 人"
          end
        end
      end

      # 图标组
      div class: "flex gap-6 justify-center items-center mx-5 h-6" do
        a href: "https://github.com/RetiredGuitar64/myblog", 
          target: "_blank", 
          rel: "nofollow", 
          title: "本站在 GitHub 上面的开源内容",
          class: "flex items-center h-full transition-transform hover:scale-110 group" do
          img src: asset("svgs/github-icon.svg"), 
              alt: "github",
              class: "w-5 h-5 opacity-80 transition-opacity group-hover:opacity-100"
        end

        a href: "https://x.com/e5YxtF6E1QCammW", 
          target: "_blank", 
          rel: "nofollow", 
          title: "我的 X 账号",
          class: "flex items-center h-full transition-transform hover:scale-110 group" do
          img src: asset("svgs/x-icon.svg"), 
              alt: "x.com",
              class: "w-5 h-5 opacity-80 transition-opacity group-hover:opacity-100"
        end

        a href: "https://crystal-lang.org/", 
          target: "_blank", 
          rel: "nofollow", 
          title: "Crystal 官方网站",
          class: "flex items-center h-full transition-transform group hover:scale-[1.15]" do
          img src: asset("svgs/crystal-lang-icon.svg"), 
              alt: "crystal-lang",
              class: "w-5 h-5 opacity-80 transition-opacity group-hover:opacity-100"
        end
      end
    end
  end
end
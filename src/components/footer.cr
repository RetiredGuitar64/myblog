class Footer < BaseComponent
  def render
    section class: "flex flex-col sm:flex-row items-center justify-center gap-6 text-sm text-gray-800" do
      # 文本信息组
      div class: "flex flex-wrap items-center justify-center gap-5" do
        span class: "font-medium hover:text-black transition-colors h-6 flex items-center ml-5" do
          text "Crystal China"
        end

        a "spider.yuxuan@gmail.com", 
          href: "mailto:spider.yuxuan@gmail.com",
          class: "hover:text-black underline underline-offset-4 decoration-gray-300 hover:decoration-gray-500 transition-all h-6 flex items-center"

        span(
          class: "bg-gray-100 px-3 py-0.5 rounded-full hover:bg-gray-200 transition-colors h-6 flex items-center",
          hx_trigger: "load,every 2m",
          hx_patch: Htmx::OnlineUsers.with(user_id: current_user.try(&.id)).path,
          hx_include: "[name='_csrf']"
        ) do
          span class: "inline-flex items-center gap-1" do
            tag "svg", width: 8, height: 8, viewBox: "0 0 8 8", class: "text-green-500 fill-current" do
              tag "circle", cx: "4", cy: "4", r: "4"
            end
            text "在线 #{ONLINE_USER_COUNTER.keys.size} 人 • 游客 #{ONLINE_IP_COUNTER.keys.size} 人"
          end
        end
      end

      # 图标组
      div class: "flex justify-center items-center gap-6 h-6 mx-5" do
        a href: "https://github.com/RetiredGuitar64/myblog", 
          target: "_blank", 
          rel: "nofollow", 
          title: "本站在 GitHub 上面的开源内容",
          class: "group hover:scale-110 transition-transform h-full flex items-center" do
          img src: asset("svgs/github-icon.svg"), 
              alt: "github",
              class: "w-5 h-5 opacity-80 group-hover:opacity-100 transition-opacity"
        end

        a href: "https://x.com/e5YxtF6E1QCammW", 
          target: "_blank", 
          rel: "nofollow", 
          title: "我的 X 账号",
          class: "group hover:scale-110 transition-transform h-full flex items-center" do
          img src: asset("svgs/x-icon.svg"), 
              alt: "x.com",
              class: "w-5 h-5 opacity-80 group-hover:opacity-100 transition-opacity"
        end

        a href: "https://crystal-lang.org/", 
          target: "_blank", 
          rel: "nofollow", 
          title: "Crystal 官方网站",
          class: "group hover:scale-[1.15] transition-transform h-full flex items-center" do
          img src: asset("svgs/crystal-lang-icon.svg"), 
              alt: "crystal-lang",
              class: "w-5 h-5 opacity-80 group-hover:opacity-100 transition-opacity"
        end
      end
    end
  end
end
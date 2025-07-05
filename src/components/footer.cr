class Footer < BaseComponent
  def render
    section class: "tool-bar margin-block", style: "margin-top: 10px;" do
      text "Crystal China"
      a "spider.yuxuan@gmail.com", href: "mailto:spider.yuxuan@gmail.com"
      hr "aria-orientation": "vertical"
      a href: "https://github.com/RetiredGuitar64/myblog", target: "_blank", rel: "nofollow", title: "本站在 GitHub 上面的开源内容" do
        img src: asset("svgs/github-icon.svg"), alt: "github"
      end
      a href: "https://x.com/e5YxtF6E1QCammW", target: "_blank", rel: "nofollow", title: "我的 X 账号" do
        img src: asset("svgs/x-icon.svg"), alt: "x.com"
      end
      a href: "https://crystal-lang.org/", target: "_blank", rel: "nofollow", title: "Crystal 官方网站" do
        img src: asset("svgs/crystal-lang-icon.svg"), alt: "crystal-lang"
      end
    end
  end
end

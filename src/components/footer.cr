class Footer < BaseComponent
  def render
    text "Crystal China"
    br
    section class: "tool-bar margin-block" do
      a "admin@crystal-china.org", href: "mailto:admin@crystal-china.org"
      hr "aria-orientation": "vertical"
      a href: "https://github.com/crystal-china", target: "_blank", rel: "nofollow", title: "本站在 GitHub 上面的开源内容" do
        img src: asset("svgs/github-icon.svg"), alt: "github"
      end
      a href: "https://x.com/crystalchinaorg", target: "_blank", rel: "nofollow", title: "本站的 Twitter 账号" do
        img src: asset("svgs/twitter-icon.svg"), alt: "twitter"
      end
      a href: "https://crystal-lang.org/", target: "_blank", rel: "nofollow", title: "Crystal 官方网站" do
        img src: asset("svgs/crystal-lang-icon.svg"), alt: "crystal-lang"
      end
    end
  end
end

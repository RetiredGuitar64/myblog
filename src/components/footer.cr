class Footer < BaseComponent
  def render
    section class: "tool-bar margin-block", style: "margin-top: 10px;" do
      text "Crystal China"
      a "admin@crystal-china.org", href: "mailto:admin@crystal-china.org"
      hr "aria-orientation": "vertical"
      a href: "https://github.com/crystal-china", target: "_blank", rel: "nofollow", title: "本站在 GitHub 上面的开源内容" do
        img src: asset("svgs/github-icon.svg"), alt: "github"
      end
      a href: "https://x.com/crystalchinaorg", target: "_blank", rel: "nofollow", title: "本站的 X 账号" do
        img src: asset("svgs/x-icon.svg"), alt: "x.com"
      end
      a href: "https://crystal-lang.org/", target: "_blank", rel: "nofollow", title: "Crystal 官方网站" do
        img src: asset("svgs/crystal-lang-icon.svg"), alt: "crystal-lang"
      end
    end
  end
end

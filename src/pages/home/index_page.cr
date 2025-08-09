class Home::IndexPage < MainLayout
  def content
    div class: "" do
      h1 "RetiredGuitar64's Blog", class: "bg-black text-green-500"

      tag(
        "canvas",
        height: 300,
        width: 300,
        id: "logo-canvas",
        style: "cursor:move",
        running: "false"
      )
    end
  end

  private def github_icon_link(link, content)
    a href: link do
      text "#{content} "
      img src: asset("svgs/github-icon.svg"), alt: "github", style: "width: 15px; height: 15px;"
    end
  end
end

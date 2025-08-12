class Home::IndexPage < MainLayout
  def content
    div class: "w-full max-w-3xl mx-auto px-8 py-6" do
      # 标题部分
      h1 class: "text-3xl font-normal text-gray-700 mb-8 text-center" do
        text "RetiredGuitar64's Blog"
      end

      # 画布区域
      div class: "flex justify-center" do
        tag(
          "canvas",
          height: 300,
          width: 300,
          id: "logo-canvas",
          class: "hover:opacity-90 transition-opacity",
          style: "cursor: move",
          running: "false"
        )
      end
    end
  end

  # 保持原有的github_icon_link方法不变
  private def github_icon_link(link, content)
    a href: link do
      text "#{content} "
      img src: asset("svgs/github-icon.svg"), alt: "github", style: "width: 15px; height: 15px;"
    end
  end
end
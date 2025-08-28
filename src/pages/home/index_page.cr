class Home::IndexPage < MainLayout
  def content
    div class: "py-6 px-8 mx-auto w-full max-w-3xl" do
      # 标题部分
      h1 class: "mb-8 text-3xl font-normal text-center text-gray-700" do
        text "RetiredGuitar64's Blog"
      end

      # 画布区域
      div class: "flex justify-center" do
        tag(
          "canvas",
          height: 300,
          width: 300,
          id: "logo-canvas",
          class: "transition-opacity hover:opacity-90",
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
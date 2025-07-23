class Home::IndexPage < MainLayout
  def content
    div class: "brand-logo f-col align-items:center justify-content:center" do
      h1 "RetiredGuitar64's Blog"

      div(
        class: "latest-release-info",
        hx_trigger: "load",
        hx_get: Home::Htmx::CrystalLatestRelease.path_without_query_params,
        hx_swap: "outerHTML",
      ) do
        a href: "" do
          span class: "f-row align-items:center" do
            text "Latest release:"
            mount Shared::Spinner, text: "获取最新版本...", width: "10px"
          end
        end
      end

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

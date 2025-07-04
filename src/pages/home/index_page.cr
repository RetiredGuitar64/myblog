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

  #   div class: "f-row justify-content:space-around" do
  #     div do
  #       h2 "Official"

  #       ul class: "align-items:stretch" do
  #         li do
  #           a "Crystal website", href: "https://www.crystal-lang.org"
  #         end
  #         li do
  #           github_icon_link("https://github.com/crystal-lang", "Crystal lang")
  #         end
  #         li do
  #           a "Crystal forum", href: "https://forum.crystal-lang.org"
  #         end
  #         li do
  #           a "Play Crystal online", href: "https://play.crystal-lang.org/"
  #         end
  #       end
  #     end

  #     div do
  #       h2 "Docs/Shards"
  #       ul class: "align-items:stretch" do
  #         li do
  #           a "API document", href: "https://crystal-lang.org/api/latest/"
  #         end
  #         li do
  #           a "devdocs Crystal", href: "https://devdocs.io/crystal"
  #         end
  #         li do
  #           a "crystaldoc.info", href: "https://crystaldoc.info/"
  #         end
  #         li do
  #           a "shards.info", href: "https://shards.info/"
  #         end
  #         li do
  #           a "shardbox.org", href: "https://shardbox.org/"
  #         end
  #       end
  #     end

  #     div do
  #       h2 "Organizations"
  #       ul class: "align-items:stretch" do
  #         li do
  #           github_icon_link("https://github.com/veelenga/awesome-crystal", "Awesome Crystal")
  #         end
  #         li do
  #           github_icon_link("https://github.com/crystal-ameba", "Crystal ameba")
  #         end
  #         li do
  #           github_icon_link("https://github.com/crystal-china", "Crystal China")
  #         end
  #         li do
  #           github_icon_link("https://github.com/crystal-community", "Crystal community")
  #         end
  #         li do
  #           github_icon_link("https://github.com/crystal-lang-tools", "Crystal lang tools")
  #         end
  #       end
  #     end
  #     div do
  #       h2 "Chat"
  #       ul class: "align-items:stretch" do
  #         li do
  #           a "Discord", href: "https://discord.gg/YS7YvQy"
  #         end
  #         li do
  #           a "Reddit", href: "https://www.reddit.com/r/crystal_programming/"
  #         end
  #       end
  #     end
  #   end
  end

  private def github_icon_link(link, content)
    a href: link do
      text "#{content} "
      img src: asset("svgs/github-icon.svg"), alt: "github", style: "width: 15px; height: 15px;"
    end
  end
end

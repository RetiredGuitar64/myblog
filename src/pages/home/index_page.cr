class Home::IndexPage < MainLayout
  def content
    div class: "brand-logo f-col align-items:center justify-content:center" do
      h1 "The Crystal programming language 中文站"

      div class: "latest-release-info" do
        a href: "https://crystal-lang.org/2025/05/12/1.16.3-released/" do
          text "Latest release: "
          strong "1.16.3"
        end
      end

      tag(
        "canvas",
        height: 450,
        width: 450,
        id: "logo-canvas",
        style: "cursor:move",
      )
    end

    div class: "f-row justify-content:space-around" do
      ul class: "align-items:stretch" do
        li do
          a "Crystal 官方网站（英文）", href: "https://www.crystal-lang.org"
        end
        li do
          a "Crystal Github", href: "https://github.com/crystal-lang"
        end
        li do
          a "Crystal China Github", href: "https://github.com/crystal-china"
        end
        li do
          a "Crystal 官方社区（英文）", href: "https://forum.crystal-lang.org"
        end
        li do
          a "Discord（英文）", href: "https://discord.gg/YS7YvQy"
        end
      end

      ul class: "align-items:stretch" do
        li do
          a "API 文档（英文）", href: "https://crystal-lang.org/api/latest/"
        end
        li do
          a "shards.info (shard 搜索)", href: "https://shards.info/"
        end
        li do
          a "shardbox.org(shard 搜索)", href: "https://shardbox.org/"
        end
        li do
          a "Awesome Crystal", href: "https://github.com/veelenga/awesome-crystal"
        end
        li do
          a "r/crystal_programming（英文）", href: "https://www.reddit.com/r/crystal_programming/"
        end
      end
    end
  end
end

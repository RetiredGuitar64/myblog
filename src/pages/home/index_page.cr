class Home::IndexPage < MainLayout
  def content
    div class: "brand-logo f-col align-items:center justify-content:center" do
      tag(
        "canvas",
        height: 500,
        width: 500,
        id: "logo-canvas",
        style: "cursor:move",
      )

      div class: "latest-release-info" do
        a href: "https://crystal-lang.org/2025/05/12/1.16.3-released/" do
          text "Latest release: "
          strong "1.16.3"
        end
      end
    end
  end
end

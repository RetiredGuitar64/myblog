class Shared::Spinner < BaseComponent
  needs text : String

  def render
    div class: "f-col align-items:center" do
      img(
        class: "htmx-indicator",
        src: asset("svgs/spinning-circles.svg"),
        alt: text
      )
    end
  end
end

class Shared::Spinner < BaseComponent
  needs text : String
  needs width : String?

  def render
    div class: "f-col align-items:center" do
      opts = {
        class: "htmx-indicator",
        src:   asset("svgs/spinning-circles.svg"),
        alt:   text,
      }

      if width
        opts = opts.merge(style: "width: #{width};")
      end

      p! opts

      img(opts)
    end
  end
end

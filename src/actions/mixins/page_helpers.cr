require "autolink"
require "common_marker"

module PageHelpers
  def para_text(para, *, autolink = false)
    para = Autolink.auto_link(para) if autolink

    para do
      text para
    end
  end

  def sub_title(msg)
    tag "sub-title" do
      text msg
    end
  end

  def markdown(text)
    md = CommonMarker.new(
      text,
      options: ["unsafe"],
      extensions: ["table", "strikethrough", "autolink", "tagfilter", "tasklist"]
    )
    raw md.to_html
  end
end

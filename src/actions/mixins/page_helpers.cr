require "autolink"

module PageHelpers
  def missing_ok(msg)
    div class: "box ok" do
      text msg
    end
  end

  def missing_info(msg)
    div class: "box info" do
      strong "💡 小提示", class: "block titlebar"
      text msg
    end
  end

  def missing_warn(msg)
    div class: "box warn" do
      strong "警告", class: "block titlebar"
      text msg
    end
  end

  def missing_error(msg)
    div class: "box bad" do
      strong "错误", class: "block titlebar"
      text msg
    end
  end

  def para_text(para, *, autolink = false)
    para = Autolink.auto_link(para) if autolink

    para do
      text para
    end
  end
end

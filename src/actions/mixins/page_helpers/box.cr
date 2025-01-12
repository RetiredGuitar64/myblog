module PageHelpers::Box
  def missing_ok(msg)
    div class: "box ok" do
      markdown msg
    end
  end

  def missing_info(msg)
    div class: "box info" do
      strong "💡 小提示", class: "block titlebar"
      markdown msg
    end
  end

  def missing_warn(msg)
    div class: "box warn" do
      strong "警告", class: "block titlebar"
      markdown msg
    end
  end

  def missing_error(msg)
    div class: "box bad" do
      strong "错误", class: "block titlebar"
      markdown msg
    end
  end
end

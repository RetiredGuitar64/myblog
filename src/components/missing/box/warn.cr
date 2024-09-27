class Missing::Warn < BaseComponent
  def render(&)
    div class: "box warn" do
      strong "Warning"
      yield
    end
  end
end

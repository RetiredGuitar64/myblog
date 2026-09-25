class Forum::TopicFields(T) < BaseComponent
  needs operation : T

  def render(&)
    mount Shared::Field, attribute: operation.title, label_text: "标题", &.text_input(autofocus: "true", required: "")

    div class: "form-field" do
      label "正文", for: "topic_text_area", class: "form-label"

      mount(
        Comments::Editor,
        content: operation.content.value || "",
        current_user: current_user,
        html_id: "topic"
      ) do
        yield
      end

      mount Shared::FieldErrors, operation.content
    end
  end
end

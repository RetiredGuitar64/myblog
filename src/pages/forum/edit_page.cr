class Forum::EditPage < MainLayout
  needs topic : Topic
  needs operation : UpdateTopic

  def page_title
    "编辑主题"
  end

  def content
    section class: "#{page_container_classes} py-10" do
      article class: "app-panel mx-auto w-full max-w-3xl overflow-hidden" do
        header class: "panel-header" do
          h1 "编辑主题", class: "panel-title"
        end

        form_for Forum::Update.with(topic.id), class: "panel-body space-y-6" do
          mount Forum::TopicFields, operation: operation, current_user: current_user do
            link "取消", to: Forum::Show.with(id: topic.id), class: "form-secondary"
            submit "保存", class: "form-submit"
          end
        end
      end
    end
  end
end

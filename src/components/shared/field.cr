# This component is used to make it easier to render the same fields styles
# throughout your app.
#
# Extensive documentation at: https://luckyframework.org/guides/frontend/html-forms#shared-components
#
# ## Basic usage:
#
#    # Renders a text input by default and will guess the label name "Name"
#    mount Shared::Field, op.name
#    # Call any of the input methods on the block
#    mount Shared::Field, op.email, &.email_input
#    # Add other HTML attributes
#    mount Shared::Field, op.email, &.email_input(autofocus: "true")
#    # Pass an explicit label name
#    mount Shared::Field, attribute: op.username, label_text: "Your username"
#
# ## Customization
#
# You can customize this component so that fields render like you expect.
# For example, you might wrap it in a div with a "field-wrapper" class.
#
#    div class: "field-wrapper"
#      label_for field
#      yield field
#      mount Shared::FieldErrors, field
#    end
#
# You may also want to have more components if your fields look
# different in different parts of your app, e.g. `CompactField` or
# `InlineTextField`
class Shared::Field(T) < BaseComponent
  include Lucky::CatchUnpermittedAttribute

  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String?

  def render(&)
    label_for attribute, label_text

    # 添加默认的边框样式
    tag_defaults field: attribute, class: "border border-gray-500 rounded-lg px-1 py-1 focus:ring-2 focus:ring-blue-500 focus:border-blue-500" do |tag_builder|
      yield tag_builder
    end

    mount Shared::FieldErrors, attribute
  end

  def render
    render &.text_input
  end
end

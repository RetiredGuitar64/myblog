class Shared::Common < BaseComponent
  def render
    input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf", id: "csrf")
  end
end

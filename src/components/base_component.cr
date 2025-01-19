abstract class BaseComponent < Lucky::BaseComponent
  def current_path
    context.request.path
  end
end

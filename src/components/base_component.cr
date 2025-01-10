abstract class BaseComponent < Lucky::BaseComponent
  def current_path
    URI.parse(context.request.resource).path
  end
end

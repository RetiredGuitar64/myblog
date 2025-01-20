abstract class BaseComponent < Lucky::BaseComponent
  needs current_user : User?

  def current_path
    context.request.path
  end
end

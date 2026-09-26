require "./browser_action"

abstract class AdminAction < BrowserAction
  before require_admin

  private def require_admin
    return continue if current_user.admin?

    head 404
  end
end

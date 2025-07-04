abstract class BrowserAction < Lucky::Action
  include Lucky::ProtectFromForgery

  # By default all actions are required to use underscores.
  # Add `include Lucky::SkipRouteStyleCheck` to your actions if you wish to ignore this check for specific routes.
  include Lucky::EnforceUnderscoredRoute

  # This module disables Google FLoC by setting the
  # [Permissions-Policy](https://github.com/WICG/floc) HTTP header to `interest-cohort=()`.
  #
  # This header is a part of Google's Federated Learning of Cohorts (FLoC) which is used
  # to track browsing history instead of using 3rd-party cookies.
  #
  # Remove this include if you want to use the FLoC tracking.
  include Lucky::SecureHeaders::DisableFLoC

  accepted_formats [:html, :json], default: :html

  # This module provides current_user, sign_in, and sign_out methods
  include Authentic::ActionHelpers(User)

  def sign_in(authenticatable : User) : Nil
    super(authenticatable)
    cookies.set_raw("user_token", UserToken.generate(authenticatable))
  end

  def sign_out : Nil
    cookies.delete("user_token")
    super
  end

  # When testing you can skip normal sign in by using `visit` with the `as` param
  #
  # flow.visit Me::Show, as: UserFactory.create
  include Auth::TestBackdoor

  # By default all actions that inherit 'BrowserAction' require sign in.
  #
  # You can remove the 'include Auth::RequireSignIn' below to allow anyone to
  # access actions that inherit from 'BrowserAction' or you can
  # 'include Auth::AllowGuests' in individual actions to skip sign in.
  include Auth::RequireSignIn

  # `expose` means that `current_user` will be passed to pages automatically.
  #
  # In default Lucky apps, the `MainLayout` declares it `needs current_user : User`
  # so that any page that inherits from MainLayout can use the `current_user`
  expose current_user

  # This method tells Authentic how to find the current user
  # The 'memoize' macro makes sure only one query is issued to find the user
  private memoize def find_current_user(id : String | User::PrimaryKeyType) : User?
    UserQuery.new.id(id).first?
  end

  def build_failed_flash(op)
    msg = String.build do |io|
      op.errors.each do |(k, v)|
        io << "#{k} #{v.first}\n"
      end
    end
    flash.failure = msg
  end
end

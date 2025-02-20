abstract class BaseComponent < Lucky::BaseComponent
  include PageHelpers
  needs current_user : User?
end

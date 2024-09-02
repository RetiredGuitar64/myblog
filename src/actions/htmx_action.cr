# Include modules and add methods that are for all API requests
abstract class HtmxAction < BrowserAction
  accepted_formats [:html], default: :html

  route_prefix "/htmx"
end

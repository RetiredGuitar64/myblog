class Shared::FlashMessages < BaseComponent
  needs flash : Lucky::FlashStore

  def render
    flash.each do |flash_type, flash_message|
      # The built-in message types are success, failure and info

      case flash_type
      when "failure"
        box_class = "bad"
      when "info"
        box_class = "warn"
      else
        box_class = "ok"
      end

      div class: "box #{box_class}", flow_id: "flash", style: "width: 300px;" do
        text flash_message
      end
    end
  end
end

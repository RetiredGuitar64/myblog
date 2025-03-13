class ReplyMore < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?}
  needs page_number : Int32
  needs reply_path : String

  def render
    pagination[:replies].each do |reply|
      preferences = reply.preferences
      div class: "box f-col justify-content:center" do
        div class: "f-row justify-content:space-between", style: "" do
          div class: "f-row" do
            img src: preferences.user_avatar? || "#{asset_host}/svgs/crystal-lang-icon.svg"
            span reply.preferences.user_name
          end

          span reply.preferences.posted_at.to_s("%F %T")
        end
        hr style: "border: none; border-top: 1px solid darkgray;"
        markdown reply.content

        if current_user.nil?
          voted_types = [] of String
        else
          voted_types = VoteQuery.new.user_id(current_user.not_nil!.id).reply_id(reply.id).map &.vote_type
        end

        div class: "f-row", style: "margin-bottom: 0px;" do
          mount(
            Shared::VoteButton,
            votes: Hash(String, Int32).from_json(reply.votes.to_json),
            reply_id: reply.id,
            current_user: current_user,
            voted_types: voted_types
          )
        end
      end
    end

    div class: "f-col align-items:center" do
      if pagination[:page].try &.next_page
        a(
          hx_get: "#{reply_path}?page=#{page_number + 1}",
          hx_target: "closest div",
          # hx_trigger: "revealed",
          hx_swap: "outerHTML",
          hx_include: "#order_by"
        ) do
          text "加载更多评论"
          mount Shared::Spinner, text: "正在读取评论..."
        end
      else
        text "没有更多评论了"
      end
    end
  end
end

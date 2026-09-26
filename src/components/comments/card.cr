class Comments::Card < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs comment : Comment
  needs order_by : String
  needs show_update_success : Bool = false

  def render
    article class: comment_card_classes, id: "comment-#{comment.id}" do
      mount(
        Comments::CardContent,
        formatter: formatter,
        comment: comment,
        show_update_success: show_update_success?,
        current_user: current_user
      )

      me = current_user
      voted_types = me ? comment.votes.map(&.vote_type) : [] of String

      footer id: "comment-#{comment.id}-footer", class: "mt-2 flex flex-wrap items-end justify-between gap-x-4 gap-y-3" do
        div class: "flex min-w-0 flex-wrap items-center gap-2 text-sm" do
          mount(
            Shared::VoteButton,
            vote_counts: Hash(String, Int32).from_json(comment.vote_counts.to_json),
            comment_id: comment.id,
            current_user: me,
            voted_types: voted_types
          )
        end

        mount Comments::CardAction,
          comment: comment,
          order_by: order_by,
          current_user: me
      end

      div id: "comment-#{comment.id}-comments" do
      end
    end
  end

  private def comment_card_classes
    classes = "app-panel mt-6 px-4 py-2 sm:px-7"
    classes += comment.parent_id ? " bg-green-100 sm:ml-8" : " bg-white"
    classes
  end
end

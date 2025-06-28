class Docs::Htmx::Reply::New < DocAction
  param doc_path : String
  param user_id : Int64

  get "/docs/htmx/reply/new" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id

    component(
      Docs::Form,
      current_user: me,
      doc_path: doc_path
    )
  end
end

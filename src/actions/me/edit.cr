class Me::Edit < BrowserAction
  get "/me/edit" do
    html Me::EditPage, op: UpdateUser.new(current_user)
  end
end

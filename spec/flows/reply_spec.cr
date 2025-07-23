require "../spec_helper"

describe "Create reply to doc and reply to reply", tags: "flow" do
  it "works" do
    flow = AuthenticationFlow.new("test@example.com")
    flow.sign_up "password"
    flow.should_be_signed_in
  end
end

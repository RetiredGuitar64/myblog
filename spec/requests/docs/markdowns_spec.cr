require "../../spec_helper"

describe Docs::Markdowns do
  it "returns 404 without creating a Doc for a missing Markdown file" do
    path = "/docs/this_document_does_not_exist"

    ApiClient.new.get(path).status_code.should eq(404)
    DocQuery.new.path_index(path).first?.should be_nil
  end

  it "returns 404 when a Doc exists but its Markdown file is missing" do
    path = "/docs/old_document_without_a_file"
    SaveDoc.create!(path_index: path)

    ApiClient.new.get(path).status_code.should eq(404)
  end

  it "does not create a Doc for an encoded alias of an existing Markdown file" do
    path = "/docs/%69ndex"

    ApiClient.new.get(path).status_code.should eq(404)
    DocQuery.new.path_index(path).first?.should be_nil
  end
end

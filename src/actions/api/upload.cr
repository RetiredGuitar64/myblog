class Api::Upload < ApiAction
  include Api::Auth::SkipRequireAuthToken

  post "/api/upload" do
    source = params.from_multipart.last["source"]

    io = IO::Memory.new

    file = File.open(source.path)
    form_data = HTTP::FormData::Builder.new(io)
    form_data.field("key", FREEIMAGE_HOST_API_KEY)
    form_data.file("source", file, HTTP::FormData::FileMetadata.new(filename: source.filename))
    form_data.finish
    file.close

    response = HTTP::Client.post(
      url: "https://freeimage.host/api/1/upload",
      headers: HTTP::Headers{"content-type" => form_data.content_type},
      body: io.rewind
    )

    body = JSON.parse(response.body)

    if response.success?
      json({status: "success", image_url: body.dig("image", "display_url")}, HTTP::Status::OK)
    else
      json({status: "failed", message: body.dig("error", "message")}, HTTP::Status::BAD_REQUEST)
    end
  end
end

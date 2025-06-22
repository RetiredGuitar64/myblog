class Api::Upload < ApiAction
  post "/api/upload" do
    source = params.from_multipart.last["source"]

    # use IO.pipe instead of IO::Memory to reduce memory usage.
    # https://forum.crystal-lang.org/t/upload-image-failed-use-http-client-but-test-with-postman-work/8171/13

    reader, writer = IO.pipe
    headers = HTTP::Headers.new
    form_data = HTTP::FormData::Builder.new(writer)
    headers["Content-Type"] = form_data.content_type

    spawn do
      file = File.open(source.path) do |file|
        form_data.field("key", FREEIMAGE_HOST_API_KEY)
        form_data.file("source", file, HTTP::FormData::FileMetadata.new(filename: source.filename))
        form_data.finish
      end
    ensure
      writer.close
    end

    response = HTTP::Client.post(
      url: "https://freeimage.host/api/1/upload",
      headers: headers,
      body: reader
    )

    body = JSON.parse(response.body)

    if response.success?
      json({status: "success", image_url: body.dig("image", "display_url")}, HTTP::Status::OK)
    else
      json({status: "failed", message: body.dig("error", "message")}, HTTP::Status::BAD_REQUEST)
    end
  end
end

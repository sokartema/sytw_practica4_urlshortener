class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :url, Text
  property :opcional, Text
end

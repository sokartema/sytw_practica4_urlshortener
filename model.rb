class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :url, Text
  property :opcional, Text
  property :email, Text
  property :nickname, Text
  
end

class LuisService
  include HTTParty
  base_uri "https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/9c965eba-6e32-47f3-9d16-9e916b3cef55?verbose=true&timezoneOffset=-180&subscription-key=020e02c9643e41deb296eae0208ac34c&q="
  debug_output $stdout

  def q(text)
    result = self.class.get("#{URI::encode(text)}") 
    return {:result => result.code == 200, :body => JSON.parse(result.body,:symbolize_names => true)}
  end
end
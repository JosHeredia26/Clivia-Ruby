require "httparty"
require "json"

class TriviaAPI
  include HTTParty
  base_uri "https://opentdb.com/api.php?amount=3"

  def self.index
    response = HTTParty.get(base_uri)
    JSON.parse(response.body, symbolize_names: true)
  end
end

require "httparty"
require "json"

class Categories
  include HTTParty

  base_uri('https://expensable-api.herokuapp.com')

  def self.categories(token)
    options = {
      headers: { "Authorization": "Token token=#{token}" }
    }

    response = get('/categories', options)
    raise HTTParty::ResponseError.new(response) unless response.success?
    JSON.parse(response.body, symbolize_names: true)
  end
end
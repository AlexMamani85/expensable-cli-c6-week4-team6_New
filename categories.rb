require "httparty"
require "json"

class Categories
  include HTTParty

  base_uri("https://expensable-api.herokuapp.com")

  def self.categories(token)
    options = {
      headers: { Authorization: "Token token=#{token}" }
    }

    response = get("/categories", options)
    raise HTTParty::ResponseError, response unless response.success?

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.create_categories(token, data)
    options = {
      headers: { "Content-Type": "application/json",
                 Authorization: "Token token=#{token}" },
      body: data.to_json
    }

    response = post("/categories", options)
    # raise HTTParty::ResponseError.new(response) unless response.success?
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.delete_category(token, id)
    options = {
      headers: { Authorization: "Token token=#{token}" }
    }

    delete("/categories/#{id}", options)
  end

  def self.update(token, id, data)
    options = {
      headers: {
        "Content-Type": "application/json",
        Authorization: "Token token=#{token}"
      },
      body: data.to_json
    }

    response = patch("/categories/#{id}", options)
    raise HTTParty::ResponseError, response unless response.success?

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.add_transaction(token, data, id)
    options = {
      headers: { "Content-Type": "application/json",
                 Authorization: "Token token=#{token}" },
      body: data.to_json
    }

    response = post("/categories/#{id}/transactions", options)
    raise HTTParty::ResponseError, response unless response.success?

    JSON.parse(response.body, symbolize_names: true)
  end
end


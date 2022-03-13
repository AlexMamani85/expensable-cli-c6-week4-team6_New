require "httparty"
require "json"
require_relative "helpers"

class Show
  include HTTParty

  base_uri("https://expensable-api.herokuapp.com")

  def initialize
  @id = nil
  end

  def self.show(token, id)
    @id = id
    options = {
      headers: { Authorization: "Token token=#{token}" }
    }

    response = get("/categories/#{id}", options)
    raise HTTParty::ResponseError, response unless response.success?

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.add_show(token, data)
    options = {
        headers: { "Content-Type": "application/json",
                   Authorization: "Token token=#{token}" },
        body: data.to_json
      }
  
      response = post("/categories/#{@id}/transactions", options)
      raise HTTParty::ResponseError, response unless response.success?
  
      #JSON.parse(response.body, symbolize_names: true)
  end

  def self.delete_show(token, id)
    options = { headers: { Authorization: "Token token=#{token}" } }
    delete("/categories/#{@id}/transactions/#{id}", options)
  end

  def self.update_transaction(token, id, data)
    options = {
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token token=#{token}"
      },
      body: data.to_json
    }

    response = patch("/categories/#{@id}/transactions/#{id}", options)
    raise HTTParty::ResponseError, response unless response.success?

    JSON.parse(response.body, symbolize_names: true)
  end
end


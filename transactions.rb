require "httparty"
require "json"

class Transactions
  include HTTParty

  base_uri('https://expensable-api.herokuapp.com')

  def self.transactions(token,id_cat)
    options = {
      headers: { "Authorization": "Token token=#{token}" }
    }
    response = get("/categories/#{id_cat}/transactions", options)

 

    raise HTTParty::ResponseError.new(response) unless response.success?
    JSON.parse(response.body, symbolize_names: true)

  end

  def self.create_transaction(token,id_cat, data)
    options = {
      headers: { "Content-Type": "application/json",
        "Authorization": "Token token=#{token}"},
       body: data.to_json
    }

    response = post("/categories/#{id_cat}/transactions", options)
    # raise HTTParty::ResponseError.new(response) unless response.success?
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.update_transaction(token,id_cat, id, data)
    options = {
      headers: { 
        Authorization: "Token token=#{token}",
        "Content-Type": "application/json"
      },
      body: data.to_json
    }

    response = patch("/categories/#{id_cat}/transactions/#{id}", options)
    raise HTTParty::ResponseError.new(response) unless response.success?
    JSON.parse(response.body, symbolize_names: true)
  end


end
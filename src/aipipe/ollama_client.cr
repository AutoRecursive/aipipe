require "http/client"
require "json"

module Aipipe
  class OllamaClient
    def initialize(@base_url : String)
    end

    def generate(prompt : String, model : String, system : String? = nil)
      body = {
        model: model,
        prompt: prompt,
        system: system,
        stream: false
      }.to_json

      response = HTTP::Client.post(
        "#{@base_url}/api/generate",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: body
      )

      case response.status_code
      when 200
        json = JSON.parse(response.body)
        json["response"].as_s
      else
        raise "API error: #{response.status_code} - #{response.body}"
      end
    end
  end
end 
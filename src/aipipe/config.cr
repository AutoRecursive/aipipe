module Aipipe
  class Config
    property api_base : String
    property model : String
    property port : Int32
    
    def initialize
      @port = ENV["OLLAMA_PORT"]?.try(&.to_i) || 11434
      @api_base = ENV["OLLAMA_API_BASE"]? || "http://localhost:#{@port}"
      @model = ENV["OLLAMA_MODEL"]? || "qwen2.5"
    end
  end
end 
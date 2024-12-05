require "./spec_helper"

describe Aipipe do
  describe Aipipe::Config do
    it "loads default configuration" do
      config = Aipipe::Config.new
      config.api_base.should eq "http://localhost:11434"
      config.model.should eq "qwen2.5"
    end

    it "respects environment variables" do
      ENV["OLLAMA_API_BASE"] = "http://custom:11434"
      ENV["OLLAMA_MODEL"] = "custom-model"
      
      config = Aipipe::Config.new
      config.api_base.should eq "http://custom:11434"
      config.model.should eq "custom-model"
    end
  end

  describe Aipipe::OllamaClient do
    it "constructs proper request" do
      client = Aipipe::OllamaClient.new("http://test:11434")
      
      # Mock HTTP client here if needed
      # Add actual test implementation
    end
  end
end 
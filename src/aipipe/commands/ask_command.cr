module Aipipe
  class AskCommand < Cling::Command
    command_name "ask"
    description "Send a prompt to Ollama and get response"

    def setup
      add_argument :prompt, description: "The prompt to send to the model", required: false
      add_option :model, short: 'm', type: String, description: "Model to use"
      add_option :system, short: 's', type: String, description: "System prompt"
    end

    def run
      # 从参数或标准输入读取prompt
      input_text = if arguments[:prompt]?
        arguments[:prompt].to_s
      else
        STDIN.gets_to_end.chomp
      end

      model = options[:model]? || CLI.config.model
      system = options[:system]?

      client = OllamaClient.new(CLI.config.api_base)
      response = client.generate(input_text, model, system)
      
      puts response
    end
  end
end 
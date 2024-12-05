require "./aipipe/*"
require "option_parser"
require "log"

module Aipipe
  VERSION = "0.1.0"
  
  Log = ::Log.for(self)
  
  class CLI
    class_property config : Config = Config.new
    class_property ollama_service : OllamaService = OllamaService.new

    def self.start
      setup_logging
      setup_cleanup_handler

      begin
        ollama_service.ensure_running
      rescue ex
        Log.error { ex.message }
        STDERR.puts "Error: #{ex.message}"
        exit(1)
      end

      command = "ask"
      prompt = ""
      model = config.model
      system = nil

      OptionParser.parse do |parser|
        parser.banner = "Usage: aipipe [command] [arguments]"
        
        parser.on("-v", "--version", "Show version") do
          puts "aipipe version #{VERSION}"
          exit
        end

        parser.on("-h", "--help", "Show help") do
          puts parser
          exit
        end

        parser.on("-m MODEL", "--model=MODEL", "Specify model") { |m| model = m }
        parser.on("-s SYSTEM", "--system=SYSTEM", "System prompt") { |s| system = s }
        
        parser.unknown_args do |args|
          command = args[0]? || "ask"
          prompt = args[1]? || ""
        end
      end

      case command
      when "ask"
        handle_ask(prompt, model, system)
      else
        puts "Unknown command: #{command}"
        exit(1)
      end
    end

    private def self.setup_logging
      log_level = ENV["AIPIPE_LOG_LEVEL"]?.try { |l| ::Log::Severity.parse(l) } || ::Log::Severity::Info
      ::Log.setup do |c|
        c.bind "*", log_level, ::Log::IOBackend.new
      end
    end

    private def self.setup_cleanup_handler
      # 处理 Ctrl+C 和程序退出
      Signal::INT.trap do
        cleanup
        exit(0)
      end

      at_exit { cleanup }
    end

    private def self.cleanup
      ollama_service.cleanup
    end

    private def self.handle_ask(prompt : String, model : String, system : String?)
      input_text = prompt.empty? ? STDIN.gets_to_end.chomp : prompt
      
      client = OllamaClient.new(config.api_base)
      response = client.generate(input_text, model, system)
      puts response
    end
  end

  def self.start
    CLI.start
  end
end

Aipipe.start 
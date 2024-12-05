require "socket"

module Aipipe
  class OllamaService
    property port : Int32
    property process : Process?
    
    TIMEOUT = 30.seconds # 超时时间
    RETRY_INTERVAL = 1.second # 重试间隔

    def initialize(@port = 11434)
    end

    def ensure_running
      return true if service_running?

      start_service
      wait_for_service
    end

    def cleanup
      if process = @process
        Log.info { "Stopping Ollama service..." }
        process.terminate
      end
    end

    private def service_running?
      socket = TCPSocket.new("localhost", @port)
      socket.close
      true
    rescue
      false
    end

    private def start_service
      Log.info { "Starting Ollama service..." }
      @process = Process.new(
        "ollama",
        ["serve"],
        output: Process::Redirect::Pipe,
        error: Process::Redirect::Pipe
      )
    rescue ex
      raise "Failed to start Ollama service: #{ex.message}"
    end

    private def wait_for_service
      start_time = Time.monotonic
      
      while Time.monotonic - start_time < TIMEOUT
        return true if service_running?
        sleep RETRY_INTERVAL
      end
      
      raise "Failed to start Ollama service after #{TIMEOUT.total_seconds} seconds"
    end
  end
end 